#!/bin/bash
#
# PICO-8 handler — invoked by Master_Daemon when the PICO-8 core loads.
#
# Master_Daemon owns the lifecycle (kill on switch, zombie sweep,
# .s0 cleanup). This handler just sets up the environment and execs
# the binary.

GAMEDIR="/media/fat/games/PICO-8"
LOGDIR="/media/fat/logs/PICO-8"

cd "$GAMEDIR" || exit 1

mkdir -p "$LOGDIR" "$GAMEDIR/Carts"

# Rotate ARM-binary stdout/stderr log
mv -f "$LOGDIR/PICO-8.log" "$LOGDIR/PICO-8.prev.log" 2>/dev/null

# Free kernel page cache before launch — PICO-8 carts are small but
# this keeps RAM state clean across multicart sub-loads.
echo 3 > /proc/sys/vm/drop_caches 2>/dev/null

# FPGA settle on first launch (the FPGA was just reflashed)
sleep 1

exec ./PICO-8 -nativevideo -data "$GAMEDIR/" > "$LOGDIR/PICO-8.log" 2>&1
