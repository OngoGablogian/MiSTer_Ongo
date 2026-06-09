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

# Belt-and-suspenders .s0 cleanup — Master_Daemon already clears .s0 on
# core transitions, but MiSTer Main's auto-resume-last-file behavior can
# leave PICO-8.s0 populated when handler spawns. Clearing here at handler
# start (before binary launches, before MGL's 2-second timer) gives users
# a clean "go to OSD picker" experience on every entry. Cross-applied from
# the OpenBOR handler fix per `feedback_s0_reboot_survival_cleanup.md`.
#
# EXCEPTION: pause-menu Reset Cart writes /tmp/pico8_reset_marker before
# _exit(0). Reset needs .s0 PRESERVED so binary re-mounts the same cart.
# If marker exists: skip cleanup + delete marker. (Mirrors OpenBOR's
# pattern; same regression family — without the exception, Reset would
# break Quit/Reset asymmetry and produce black screen on Reset Cart.)
if [ -f /tmp/pico8_reset_marker ]; then
    rm -f /tmp/pico8_reset_marker 2>/dev/null
else
    rm -f /media/fat/config/PICO-8.s0 2>/dev/null
fi

# Free kernel page cache before launch — PICO-8 carts are small but
# this keeps RAM state clean across multicart sub-loads.
echo 3 > /proc/sys/vm/drop_caches 2>/dev/null

# FPGA settle on first launch (the FPGA was just reflashed)
sleep 1

# 2026-06-08 affinity fix: taskset 0x03 (both cores) so the binary's render-thread
# pin to core 1 + audio-thread pin to core 0 (mister_main.cpp) take effect. Core 0
# takes ~165M device IRQs (USB/fb/SD), core 1 is interrupt-free — render belongs on 1.
exec taskset 0x03 ./PICO-8 -nativevideo -data "$GAMEDIR/" > "$LOGDIR/PICO-8.log" 2>&1
