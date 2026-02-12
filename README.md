----
# Add this to your MiSTer 'downloader.ini' file:
```
[OngoGablogian/MiSTer_Ongo]
db_url = https://raw.githubusercontent.com/OngoGablogian/MiSTer_Ongo/db/db.json.zip
```
----

# Included Cores:
| Core |
| :---: |
| [240p Test Suite](https://github.com/burabure/240p_MiSTer)                                                                      |
| [ABC 80](https://github.com/JasonA-dev/ABC80_MiSTer)                                                                            |
| [Air Gallet (Coin-Op Collection)](https://www.patreon.com/posts/135641029)                                                      |
| [Atari Jaguar](https://github.com/greyrogue/Jaguar_MiSTer)                                                                      |
| [Battletoads](https://github.com/srg320/Arcade-Battletoads_MiSTer)                                                              |
| [BubbleUniverse](https://github.com/movievertigo/MiSTer-BubbleUniverse)                                                         |
| [DVK MC1201](https://github.com/xolod79/MC1201)                                                                                 |
| [Elan Enterprise](https://github.com/Kyp069/ep)                                                                                 |
| [Enigma2](https://github.com/nic24-rgb/Enigma2)                                                                                 |
| [Exidy Sorcerer](https://github.com/JasonA-dev/Sorcerer_MiSTer)                                                                 |
| [FM Towns](http://fpga8801.seesaa.net)                                                                                          |
| [HCRF Test Core](https://discord.com/channels/637336939212701757/1043059930543951932/1212906158608748624)                       |
| [JTSDRAM 48](https://github.com/jotego/jtbin/blob/master/deprecated/jtsdram48_20210108.rbf)                                     |
| [JTSDRAM 96](https://github.com/jotego/jtbin/blob/master/deprecated/jtsdram96_20210108.rbf)                                     |
| [Konix Multisystem](https://github.com/SavourySnaX/MiSTer_KonixMultisystem)                                                     |
| [LM80C](https://github.com/JasonA-dev/LM80C_MiSTer)                                                                             |
| [Mandelbrot](https://github.com/jacquesdriessen/MiSTer-mandelbrot)                                                              |
| [Mazinger Z (Coin-Op Collection)](https://www.patreon.com/posts/coin-op-presents-124883899)                                     |
| [Nand2Tetris (Hack)](https://github.com/sajattack/Hack_MiSTer)                                                                  |
| [Nemesis (Konami GX400)](https://github.com/GX400-Friends/gx400-bin)                                                            |
| [Nintendo Game & Watch](https://github.com/agg23/fpga-gameandwatch)                                                             |
| [Nintendo Game Boy Advance (Accuracy)](https://github.com/MiSTer-devel/GBA_MiSTer/tree/accuracy)                                |
| [Nintendo N64 (Turbo)](https://github.com/MiSTer-devel/N64_MiSTer/tree/main/releases_turbo)                                     |
| [Nintendo NES (Monochrome)](https://x.com/iequalshane/status/1702385984053109018?s=20)                                          |
| [Nintendo NES (PC10 PPU Emphasis)](https://x.com/iequalshane/status/1714695850910175269?s=20)                                   |
| [Nintendo NES (RF)](https://x.com/iequalshane/status/1619921884682002433?s=20)                                                  |
| [Nintendo NES (Test)](https://discord.com/channels/647909397477195803/737506076806611064/1423754567371460781)                   |
| [Nintendo SNES (Save States)](https://misterfpga.org/viewtopic.php?t=8459)                                                      |
| [Nintendo VS. System](https://discord.com/channels/647909397477195803/737506076806611064/1452810318370832384)                   |
| [Pretty Soldier Sailor Moon (Coin-OpCollection)](https://www.patreon.com/posts/coin-op-presents-132165001)                      |
| [RCA Studio II](https://github.com/JasonA-dev/RCAStudioII_Mister)                                                               |
| [SEGA Channel Revival](https://archive.org/details/sega-channel-revival-complete-collection)                                    |
| [SEGA Genesis](https://github.com/MiSTer-devel/Genesis_MiSTer)                                                                  |
| [SEGA System 1 & 2](https://github.com/blackwine/Arcade-SEGASYS1_MiSTer)                                                        |
| [Snake Game](https://github.com/dimonp/SnakeGame_MiSTer/)                                                                       |
| [SNK Neo Geo (Turbo)](https://github.com/ajgowans/alt-cores)                                                                    |
| [Sony PS1 (2X CPU)](https://github.com/RobertPeip/PSX_MiSTer/tree/main/releases)                                                |
| [Soyuz-Neon PC-11/16 (Uneon)](https://github.com/xolod79/UNEON)                                                                 |
| [SparcStation 5](https://github.com/Grabulosaure/ss)                                                                            |
| [SparcStation 20](https://github.com/Grabulosaure/ss)                                                                           |
| [StarForce](https://github.com/madoov/MiSTer-StarForce)                                                                         |
| [Tamagotchi P1](https://github.com/agg23/fpga-tamagotchi)                                                                       |
| [Technos 16 (Coin-Op Collection)](https://www.patreon.com/posts/coin-op-presents-120641719)                                     |
| [VTech Laser 350/500/700](https://github.com/JasonA-dev/Laser500_MiSTer)                                                        |
| [Zet98 (PC-98)](http://fpga8801.seesaa.net/)                                                                                    |
| [zx48 (ZX Spectrum 48K)](https://github.com/Kyp069/zx48-MiSTer)                                                                 |


> [!IMPORTANT]
> The CD-i core is now officially released and included with update_all! If you've previously added the lines below to you MiSTer.ini file, please remove them.

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


> [!IMPORTANT]
> Since the release of Downloader v2.3, I'd recommended adding the lines below to your 'downloader.ini' file. This will help avoid potential issues, for instance, when a file is removed from this repository after being added to one of the more "official" repositories.

```
[MiSTer]
file_checking = 'exhaustive'
```

----

# MRA:
| MRA |
| :---: |
| [Bubble Bobble Ultra (v1.0)](https://www.romhacking.net/hacks/754)                                                 |
| [Chuckie Egg](https://arlagames.itch.io/chuckie-egg-arcade)                                                        |
| [Dangun Feveron (No Discomen) (v1.0)](https://www.romhacking.net/hacks/7544)                                       |
| [DoDonPachi (Ship Color Hack)](https://epozzobon.it/re/ddonpach/patcher)                                           |
| [DoDonPachi (Ship Color No BGM)](https://epozzobon.it/re/ddonpach/patcher)                                         |
| [DoDonPachi Trainer (v1.11)](https://github.com/alamone/ddonpachj-trainer)                                         |
| [Gradius II (ver.xh)](https://github.com/Toryalai1/Arcade_Offset/tree/main/release/_Arcade%20Offset/_Gradius%20II) |
| [Hotdog Storm (Requires Patreon CAVE Core)](https://www.patreon.com/nullobject)                                    |
| [Kana Kong Arcade (v1.01)](https://www.romhacking.net/hacks/6689)                                                  |
| [Out Zone (Visibility Hack)](https://www.romhacking.net/hacks/9236/)                                               |
| [Pac-Yuyu Arcade (v1.0)](https://www.romhacking.net/hacks/6695)                                                    |
| [Pacu Pacu (v1.1)](https://discord.com/channels/647909397477195803/1046942006942900304/1408732261028860004)        |
| [Pollen Angel](https://arlagames.itch.io/pollen-angel-pacman-hardware)                                             |
| [Pop Flamer (Bootleg conversion) (Fixed)](https://github.com/MiSTer-devel/Arcade-NaughtyBoy_MiSTer)                |
| Salamander (SP ver. clone)                                                                                         |
| Salamander (SP ver. clone Neo)                                                                                     |
| [SlapFight (Visibility Hack)](https://www.romhacking.net/hacks/9236/)                                              |
| [Terra Cresta (Visibility Hack)](https://www.romhacking.net/hacks/9236/)                                           |
| [Tiger Heli (Visibility Hack)](https://www.romhacking.net/hacks/9236/)                                             |
| [Toryumon DX](https://www.romhacking.net/hacks/8319/)                                                              |
| [Truxton II - Tatsujin Oh (Round Select)](http://alamone.net/)                                                     |
| [Twin Cobra (Visibility Hack)](https://www.romhacking.net/hacks/9236/)                                             |
| Twin Twist (Twin Cobra Hack)                                                                                       |
| [Warriors of Fate - Special (v1.0)](https://www.romhacking.net/hacks/7550)                                         |

----

# Other Stuff:
| Other |
| :---: |
| [Natrox MiSTer Utilities](https://github.com/Natrox/MiSTer_Utils_Natrox)                                                  |
| MiSTer rclone for Savestates & Screenshots                                                                                |
| [Vectrex Overlays](https://github.com/MiSTer-devel/Vectrex_MiSTer/tree/master/overlays)                                   |
| [Sho's NES Palettes (v2.4)](https://archive.org/details/nes-palettes-v-2.4)                                               |
| [Pixeltao NES Palettes](https://pixeltao.itch.io/)                                                                        |
| [GameBoyPalettes (icelaglace)](https://github.com/icelaglace/GameBoyPalettes)                                             |
| [TrashUncle Game Boy Shadow Masks](https://github.com/trashuncle/Gameboy_Palettes)                                        |
| [RetroFonse Presets](https://twitter.com/retrofonse/status/1602172002017517571?s=20)                                      |
| [Scanlines - Adaptive (Midpoint)](https://discord.com/channels/647909397477195803/811089485495402497/1074842158722465883) |
| [Scanlines - Adaptive (No Boost)](https://discord.com/channels/647909397477195803/811089485495402497/962786206029058179)  |
| [Phaedrux LG C1 Settings](https://discord.com/channels/647909397477195803/647909398072655907/1082827830913671169)         |
| [Bear N64 Audio Filter Presets](https://discord.com/channels/647909397477195803/1096015979055697940/1271142144135925771)  |
| LCD Scale5x Shadow Masks                                                                                                  |

----

> [!TIP]
> Here are some other recommended repositories you can add to your 'downloader.ini' file.

[MiSTer Unstable Nightlies](https://github.com/MiSTer-unstable-nightlies)
```
[unstable_nightlies_folder]
db_url = https://raw.githubusercontent.com/MiSTer-unstable-nightlies/Unstable_Folder_MiSTer/main/db_unstable_nightlies_folder.json
```

[MiSTer FPGA D93 Whitepoint Filter (danmons)](https://github.com/danmons/MiSTer_D93)
```
[danmons/MiSTer_D93]
db_url = https://raw.githubusercontent.com/danmons/MiSTer_D93/db/db.json.zip
```

[MiSTer Game Boy Palettes (davewongillies)](https://github.com/davewongillies/MiSTer-gameboy-palettes)
```
[davewongillies/gameboy_palettes]
db_url = https://raw.githubusercontent.com/davewongillies/MiSTer-gameboy-palettes/db/db.json.zip
```

[MiSTer Addons Reflex Adapt Firmware](https://github.com/misteraddons/Reflex-Adapt)
```
[misteraddons/reflexadapt]
db_url = https://github.com/misteraddons/Reflex-Adapt/raw/main/reflexadapt.json.zip
```

----

> [!NOTE]
> If you are a developer of one of the cores included in this repository and would like it removed, please create an issue on the [GitHub page](https://github.com/OngoGablogian/MiSTer_Ongo/issues).

----
