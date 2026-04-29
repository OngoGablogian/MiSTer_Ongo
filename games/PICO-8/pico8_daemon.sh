#!/bin/bash
# pico8_daemon.sh — Auto-start PICO-8 emulator when core loads
#
# Uses mkdir as atomic lock to guarantee only ONE daemon runs.
# Uses wait to guarantee only ONE binary runs at a time.
# No race conditions — process must fully exit before next spawn.

LOCKDIR="/tmp/pico8_daemon.lock"
PIDFILE="/tmp/pico8_arm.pid"
GAMEDIR="/media/fat/games/PICO-8"
BINARY="$GAMEDIR/PICO-8"
ARGS="-nativevideo -data $GAMEDIR/"

# Clear any stale .s0 from a previous boot so MiSTer doesn't auto-mount
# a previously-selected cart on core load
rm -f /media/fat/config/PICO-8.s0

# Sweep any rogue PICO-8 binary left over from a previous daemon
# instance that failed to kill its child cleanly (deploy script
# kill, crash, manual SSH restart). Filter by /proc/$pid/cwd so
# we only kill OUR binary — defensive even though PICO-8 is the
# only core named "PICO-8" today.
for pid in $(pidof PICO-8 2>/dev/null); do
    cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null)
    if [ "$cwd" = "$GAMEDIR" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

# Prevent multiple daemon instances
if ! mkdir "$LOCKDIR" 2>/dev/null; then
    OLDPID=$(cat "$LOCKDIR/pid" 2>/dev/null)
    if [ -n "$OLDPID" ] && kill -0 "$OLDPID" 2>/dev/null; then
        exit 0
    fi
    rm -rf "$LOCKDIR"
    mkdir "$LOCKDIR" 2>/dev/null || exit 0
fi
echo $$ > "$LOCKDIR/pid"

CHILD=""
cleanup() {
    [ -n "$CHILD" ] && kill $CHILD 2>/dev/null
    rm -f "$PIDFILE"
    rm -rf "$LOCKDIR"
    exit 0
}
trap cleanup TERM INT

FIRST_LOAD=1
while true; do
    CUR=$(cat /tmp/CORENAME 2>/dev/null)

    if [ "$CUR" = "PICO-8" ] && [ -z "$CHILD" ]; then
        # No binary running — start one
        if [ "$FIRST_LOAD" = "1" ]; then
            sleep 1  # FPGA settle on first load only
            FIRST_LOAD=0
        fi
        mkdir -p /media/fat/logs/PICO-8
        mv -f /media/fat/logs/PICO-8/PICO-8.log /media/fat/logs/PICO-8/PICO-8.prev.log 2>/dev/null
        $BINARY $ARGS > /media/fat/logs/PICO-8/PICO-8.log 2>&1 &
        CHILD=$!
        echo $CHILD > "$PIDFILE"
    fi

    if [ -n "$CHILD" ]; then
        if ! kill -0 $CHILD 2>/dev/null; then
            # Process exited (hot-swap or crash) — reap it
            wait $CHILD 2>/dev/null
            CHILD=""
            rm -f "$PIDFILE"
            # Don't sleep — restart fast on next iteration
            continue
        fi
        if [ "$CUR" != "PICO-8" ]; then
            # User left the core — kill binary aggressively so it
            # cannot keep writing to DDR3 while another core tries
            # to render. SIGTERM grace window, then SIGKILL — zepto8
            # cleanup paths can hang under SDL dummy + audio thread.
            kill $CHILD 2>/dev/null
            sleep 1
            kill -9 $CHILD 2>/dev/null
            wait $CHILD 2>/dev/null
            CHILD=""
            FIRST_LOAD=1
            rm -f "$PIDFILE"
            rm -f /media/fat/config/PICO-8.s0
        fi
    fi

    sleep 1
done
