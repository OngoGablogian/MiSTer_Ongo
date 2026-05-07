# MiSTer PICO-8

A PICO-8 fantasy console emulator for MiSTer FPGA with native video and audio output. The FPGA handles video timing and output directly, bypassing the MiSTer scaler for zero-lag CRT support.

## Features

- **Native FPGA video output** — 256×224 @ 60.10Hz, byte-for-byte identical to the MiSTer NES core's default timing. Exact NES pixel clock (5.369 MHz from NTSC colorburst crystal), 47.68 µs active time, 38 lines of vertical blanking. 128×128 source is 2× horizontal + 1.75× vertical (Bresenham 4/7) so all source pixels display at 8:7 pixel aspect — same proportions as NES games on a CRT TV
- **Native FPGA audio output** — 48 kHz signed 16-bit stereo via DDR3 ring buffer and dual-clock DCFIFO (same audio path as NES/SNES/Genesis cores)
- **CRT support** — scanlines, shadow masks, and analog video output for CRT displays
- **MiSTer OSD integration** — load .p8 and .p8.png carts from the file browser
- **Hot-swap carts** — load a new cart from the OSD while a game is playing
- **Save states** — 4 slots per cart, NES-style UX, OSD-driven and F1–F4 keyboard shortcuts (see [Save States](#save-states) below)
- **Controller support** — d-pad, analog stick, and button mapping through MiSTer's input system
- **Auto-launch** — the emulator starts automatically when the core is loaded

## Quick Install

The recommended path is via the **MiSTer Frontier** combined database, which auto-deploys the PICO-8 core (and any other Frontier core you opt into) every time you run `update_all`.

Add this to `/media/fat/downloader.ini` on your MiSTer's SD card:

```ini
[MiSTerOrganize/MiSTer_Frontier]
db_url = https://raw.githubusercontent.com/MiSTerOrganize/MiSTer_Frontier/db/db.json.zip
filter = pico-8
```

The `filter = pico-8` line tells the downloader to install **only** PICO-8 from the Frontier database. Drop the filter line if you want every Frontier core, or pick others — see the [Frontier README](https://github.com/MiSTerOrganize/MiSTer_Frontier#choosing-what-to-install-filters) for the full filter list.

After editing `downloader.ini`:

1. Run `update_all` from MiSTer's Scripts menu — installs the FPGA core, ARM binary, BIOS (`bios.p8`), handler script, and docs
2. Run `Scripts/Install_MiSTer_Frontier.sh` once — registers the Master Daemon that auto-launches the emulator. Idempotent
3. Place your `.p8` or `.p8.png` carts in `/media/fat/games/PICO-8/Carts/`
4. Load **PICO-8** from the MiSTer console menu — the emulator launches automatically

**Inspecting the manifest:** [DB Inspector for MiSTer_Frontier](https://theypsilon.github.io/DB-Inspector_MiSTer/?database-url=https%3A%2F%2Fraw.githubusercontent.com%2FMiSTerOrganize%2FMiSTer_Frontier%2Fdb%2Fdb.json.zip) — every file, hash, size, and tag visible in the browser. Useful for verifying which files a given filter would install before you run `update_all`.

## Manual Install

Extract the release zip to the root of your MiSTer SD card (`/media/fat/`):

```
/media/fat/
├── _Other/
│   └── PICO-8_YYYYMMDD.rbf               FPGA core (dated build)
├── docs/
│   └── PICO-8/
│       └── README.md                      Documentation
├── games/
│   └── PICO-8/
│       ├── PICO-8                         ARM binary (emulator)
│       ├── pico8_daemon.sh                Auto-launch daemon
│       ├── bios.p8                        BIOS
│       └── Carts/                         Place your .p8 and .p8.png carts here
├── logs/
│   └── PICO-8/                            Debug logs
├── saves/
│   └── PICO-8/                            Cart-data saves (created automatically when a cart calls cartdata())
├── savestates/
│   └── PICO-8/                            Save state files (created automatically — <cart>_<slot>.ss)
└── Scripts/
    └── Install_PICO-8.sh                  Install script
```

## Usage

1. Load **PICO-8** from the MiSTer console menu
2. The emulator starts automatically
3. Press the **menu button** to open the MiSTer OSD
4. Select **Load Cart** to browse and load a cart
5. Load a different cart from the OSD at any time during gameplay

## Controls

| Button              | PICO-8      |
|---------------------|-------------|
| D-pad / Analog stick | Movement   |
| A                   | O (confirm) |
| X                   | X (action)  |
| Start               | Pause       |
| Menu button         | MiSTer OSD  |

## Save States

Same UX as the MiSTer NES core — 4 slots per cart, OSD pause-menu driven, with optional F1–F4 keyboard shortcuts.

### How to use

**Via the MiSTer OSD pause menu:**

1. Open the MiSTer OSD (Menu button on your controller).
2. Pick **Save Slot** to choose slot 1, 2, 3, or 4.
3. Pick **Save State** to save the current cart's state to that slot.
4. Pick **Load State** to restore the saved state from the selected slot.

**Via keyboard shortcuts (USB keyboard plugged into the MiSTer):**

| Key      | Action               |
|----------|----------------------|
| F1       | Load slot 1          |
| F2       | Load slot 2          |
| F3       | Load slot 3          |
| F4       | Load slot 4          |
| Alt + F1 | Save to slot 1       |
| Alt + F2 | Save to slot 2       |
| Alt + F3 | Save to slot 3       |
| Alt + F4 | Save to slot 4       |

### Where save state files live

`/media/fat/savestates/PICO-8/<cart>_<slot>.ss`

For example, saving slot 1 of a cart called `vracing_title.p8` produces `/media/fat/savestates/PICO-8/vracing_title_0.ss` (slots are zero-indexed in the filename: slot 1 → `_0`, slot 2 → `_1`, etc.).

Save state files are independent of regular cart save data (`.p8d.txt` files in `/media/fat/saves/PICO-8/`). The two systems coexist — `cartdata()` persistence works normally for carts that use it.

### What gets saved

- Full cart RAM (graphics, sound, music, code, persistent / cartdata region)
- Cart's currently-active globals (`_init`, `_update`, `_draw`, all variables)
- Audio sequencer state (which sfx/music is playing, channel positions, fade)
- Pause menu items (including any cart-defined `menuitem()` callbacks)
- For multicart games: the currently-active sub-cart filename, so loads restore to the right sub-cart

### Multicart save state notes

Most multicart games (e.g., Pico Sonic) work transparently — save and load operate on whatever sub-cart is currently active and the state is preserved across sub-cart transitions in-game.

**Known UX wart for cart-mismatch loads:** if you save while on one sub-cart, then change carts (via the in-cart Reset Cart pause menu, or by hot-swapping a different cart from the OSD), then press Load State — the **first** Load press will reload the saved cart but show its default state, and you need to press Load State a **second** time for the saved state to fully restore. This is unavoidable in PICO-8's multicart model: many sub-carts only run correctly when started by their parent cart's `load("subcart", breadcrumb, params)` call (which passes state through `params`/`breadcrumb`). Forcing the sub-cart to start standalone crashes it. The two-load workflow is the lesser evil.

If you save+load on the same sub-cart without changing carts in between, no double-press is needed. The two-load behavior only affects the cart-mismatch case.

### Tested compatibility

Save states have been verified working on:

- Single-cart games (Adventure Time World 2, A Hat on Time, A Small Dragon Kid Game, etc.)
- Multicart games on the same sub-cart (Pico Sonic, Virtua Racing, Freezing Knights)
- Multicart games across sub-cart transitions (with the two-load behavior described above)

Audio resumes from saved music position, visuals resume from saved frame, gameplay continues from saved state.

## CRT Display Notes

PICO-8 ships with **video timing identical to the MiSTer NES core's default output**: 256×224 active, 262 lines total, 60.10 Hz refresh, exact NES pixel clock. Game pixels render at **8:7 pixel aspect** (slightly wider than tall) — the same proportions an NES or SNES has on a CRT TV. The 128×128 PICO-8 source is doubled horizontally to 256 and Bresenham-scaled vertically (1.75×) to 224. **No source pixels are cropped.**

The result: PICO-8 games occupy the same physical area on a CRT as NES games, with identical scan timing, identical safe-area margin (38 lines of vertical blanking), and identical CRT lock behavior. Consumer NTSC CRTs that show NES games correctly will show PICO-8 games correctly. PVM/BVM users get the same image size they'd see for a real NES cart.

### Fine-tuning image position

The OSD has **`H Position (CRT)`** and **`V Position (CRT)`** options (±3 pixels) for fine-tuning image centering on individual CRTs. These adjust the timing porches so the picture shifts on the tube without changing refresh rate. No effect on HDMI (the scaler auto-centers).

### HDMI / scaler users

If you're on HDMI, Direct Video, or VGA-via-scaler and want extra margin around the image, set `vscale_border=N` in `MiSTer.ini` (1–399 pixels). Framework-level border, only applies through the MiSTer scaler — bypassed by pure 15kHz analog out of the FPGA.

## Architecture

Hybrid core: FPGA handles video/audio output and controller input, ARM CPU runs the PICO-8 emulator (zepto8).

- **ARM** renders 128×128 RGBA frames → RGB565 → DDR3
- **FPGA** reads DDR3, scales 128×128 → 256×224 (2× H, 1.75× V via Bresenham), outputs native video (15,746 Hz horizontal, exact NES timing)
- **Audio** — ARM writes 48 kHz S16 stereo to DDR3 ring buffer, FPGA reads and outputs via I2S/SPDIF/DAC
- **Controller** — USB → Main_MiSTer → hps_io → FPGA → DDR3 → ARM
- **Cart loading** — OSD file browser → hps_io ioctl → FPGA → DDR3 → ARM

## Building from Source

### ARM Binary (GitHub Actions)

Built automatically by CI using QEMU ARM emulation with `arm32v7/debian:bullseye-slim`. Push to `main` to trigger.

### FPGA Core (Quartus)

Requires Intel Quartus Prime Lite 17.0. Project in `fpga/`, RTL in `fpga/rtl/`, framework in `fpga/sys/` (DO NOT MODIFY sys/).

## Credits

- **zepto8** — PICO-8 emulator by Sam Hocevar (WTFPL license)
- **3SX MiSTer** — reference architecture for ARM-to-FPGA native video
- **MiSTer FPGA** — open-source FPGA retro platform

## License

GPL-3.0
