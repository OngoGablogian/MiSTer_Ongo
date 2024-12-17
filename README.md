```ini
[OngoGablogian/MiSTer_Ongo]
db_url = https://raw.githubusercontent.com/OngoGablogian/MiSTer_Ongo/db/db.json.zip
```
----

# Included Cores:
| Core |
| :---: |
| [240p Test Suite](https://github.com/burabure/240p_MiSTer)                                                                      |
| [Battletoads](https://github.com/srg320/Arcade-Battletoads_MiSTer)                                                              |
| [DVK MC1201](https://github.com/xolod79/MC1201)                                                                                 |
| [Elan Enterprise](https://github.com/Kyp069/ep)                                                                                 |
| [Enigma2](https://github.com/nic24-rgb/Enigma2)                                                                                 |
| [Epoch - Super Cassette Vision](https://gitlab.com/ReverendGumby/SuperCassetteVision_MiSTer)                                    |
| [FM Towns](http://fpga8801.seesaa.net)                                                                                          |
| [Game & Watch](https://github.com/agg23/fpga-gameandwatch)                                                                      |
| [JTSDRAM 48](https://github.com/jotego/jtbin/blob/master/deprecated/jtsdram48_20210108.rbf)                                     |
| [JTSDRAM 96](https://github.com/jotego/jtbin/blob/master/deprecated/jtsdram96_20210108.rbf)                                     |
| [Konix Multisystem](https://github.com/SavourySnaX/MiSTer_KonixMultisystem)                                                     |
| [Mandelbrot](https://github.com/jacquesdriessen/MiSTer-mandelbrot)                                                              |
| [Nand2Tetris (Hack)](https://github.com/sajattack/Hack_MiSTer)                                                                  |
| [Nemesis (Konami GX400)](https://github.com/GX400-Friends/gx400-bin)                                                            |
| [Nintendo N64 (Test Cores)](https://github.com/MiSTer-devel/N64_MiSTer)                                                         |
| [Nintendo N64 (Turbo)](https://github.com/MiSTer-devel/N64_MiSTer/tree/main/releases_turbo)                                     |
| [Nintendo NES (Monochrome)](https://x.com/iequalshane/status/1702385984053109018?s=20)                                          |
| [Nintendo NES (PC10 PPU Emphasis)](https://x.com/iequalshane/status/1714695850910175269?s=20)                                   |
| [Nintendo NES (RF)](https://x.com/iequalshane/status/1619921884682002433?s=20)                                                  |
| [Philips CD-i](https://github.com/Slamy/CDi_MiSTer)                                                                             |
| [SEGA System 1 & 2](https://github.com/blackwine/Arcade-SEGASYS1_MiSTer)                                                        |
| [SNK Neo Geo (Turbo)](https://discord.com/channels/647909397477195803/1075091985007902812/1125865411733377145)                  |
| [Sony PS1 (2X CPU)](https://github.com/RobertPeip/PSX_MiSTer/tree/main/releases)                                                |
| [Soyuz-Neon PC-11/16 (Uneon)](https://github.com/xolod79/UNEON)                                                                 |
| [SparcStation 5](https://github.com/Grabulosaure/ss)                                                                            |
| [SparcStation 20](https://github.com/Grabulosaure/ss)                                                                           |
| [Tamagotchi P1](https://github.com/agg23/fpga-tamagotchi)                                                                       |
| [Zet98 (PC-98)](http://fpga8801.seesaa.net/)                                                                                    |
| [zx48 (ZX Spectrum 48K)](https://github.com/Kyp069/zx48-MiSTer)                                                                 |


> [!IMPORTANT]  
> For the CD-i core to function properly you need a MiSTer Main built from [this commit](https://github.com/MiSTer-devel/Main_MiSTer/commit/b79e95ee97915f3fe1ddee9e6a5dccf38ce3137e) or later. If you previously added the lines below to your MiSTer.ini file, please remove them.

```
[CD-i]
main=MiSTer_CDi
```


> [!IMPORTANT]  
> The Neo Geo Pocket Color MRA in the consoles folder requires that you symlink the "_Arcade/Cores" folder to "_Console/cores". This is necessary until the core leaves beta. To do this, enter the command listed below into the Linux command line on your MiSTer. 

```
ln -s /media/fat/_Arcade/cores /media/fat/_Console/cores
```


> [!IMPORTANT]  
> For the Soyuz-Neon PC-11/16 (Uneon) core to function properly you must add the lines below to your MiSTer.ini file.

```
[Uneon]
main=MiSTer_Uneon
```


----

# MRA:
| MRA |
| :---: |
| [Bubble Bobble Ultra (v1.0)](https://www.romhacking.net/hacks/754)              |
| [Chuckie Egg](https://arlagames.itch.io/chuckie-egg-arcade)                     |
| [Dangun Feveron (No Discomen) (v1.0)](https://www.romhacking.net/hacks/7544)    |
| [DoDonPachi (Ship Color Hack)](https://epozzobon.it/re/ddonpach/patcher)        |
| [DoDonPachi (Ship Color No BGM)](https://epozzobon.it/re/ddonpach/patcher)      |
| [DoDonPachi Trainer (v1.11)](https://github.com/alamone/ddonpachj-trainer)      |
| [Hotdog Storm (Requires Patreon CAVE Core)](https://www.patreon.com/nullobject) |
| [Kana Kong Arcade (v1.01)](https://www.romhacking.net/hacks/6689)               |
| [Pac-Yuyu Arcade (v1.0)](https://www.romhacking.net/hacks/6695)                 |
| [Pollen Angel](https://arlagames.itch.io/pollen-angel-pacman-hardware)          |
| [Toryumon DX](https://www.romhacking.net/hacks/8319/)                           |
| [Truxton II - Tatsujin Oh (Round Select)](http://alamone.net/)                  |
| [Warriors of Fate - Special (v1.0)](https://www.romhacking.net/hacks/7550)      |

----

# Other Stuff:
| Other |
| :---: |
| [Natrox MiSTer Utilities](https://github.com/Natrox/MiSTer_Utils_Natrox)                                                  |
| [Names_MiSTer (names_CHAR18_Common_US)](https://github.com/ThreepwoodLeBrush/Names_MiSTer)                                |
| [Vectrex Overlays](https://github.com/MiSTer-devel/Vectrex_MiSTer/tree/master/overlays)                                   |
| [Sho's NES Palettes (v2.4)](https://archive.org/details/nes-palettes-v-2.4)                                               |
| [openfpga-palettes](https://github.com/davewongillies/openfpga-palettes)                                                  |
| [TrashUncle's Gameboy Palettes](https://github.com/trashuncle/Gameboy_Palettes)                                           |
| [GameBoyPalettes (icelaglace)](https://github.com/icelaglace/GameBoyPalettes)                                             |
| [RetroFonse Presets](https://twitter.com/retrofonse/status/1602172002017517571?s=20)                                      |
| [Scanlines - Adaptive (Midpoint)](https://discord.com/channels/647909397477195803/811089485495402497/1074842158722465883) |
| [Scanlines - Adaptive (No Boost)](https://discord.com/channels/647909397477195803/811089485495402497/962786206029058179)  |
| [Phaedrux LG C1 Settings](https://discord.com/channels/647909397477195803/647909398072655907/1082827830913671169)         |
| [Bear N64 Audio Filter Presets](https://discord.com/channels/647909397477195803/1096015979055697940/1271142144135925771)  |
| LCD Scale5x Shadow Masks                                                                                                  |

----
