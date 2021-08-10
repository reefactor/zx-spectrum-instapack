
# ZX-SPECTRUM instant all-in pack

A currated collection of best [emulators](emul), [programming books](books) and [software](ZX).
All you need to [spend time](overboot.asm) on a [desert island](#play-offline).

#### Online

Try [jVGS](https://reefactor.github.io/zx-spectrum-instapack/emul/jVGS/jvgs-offline.html) 
or [Qaop](https://reefactor.github.io/zx-spectrum-instapack/emul/QAOP/qaop.html#ay#128) 
emulators online.

### Top ZX-SPECTRUM emulators

| Host OS | Emulator | Source code | Last updated | Author | Supported file formats | 
|:---:|:---:|:---:|:---:|---|---|
|Crossplatform|[**USP** - **Unreal Speccy Portable** fork](emul/USP)| C++ [git](https://github.com/djdron/UnrealSpeccyP) [snapshot v0.0.86.12](emul/src/UnrealSpeccyP-v0.0.86.12.tgz)|2020| djdron, scor |  TRD, FDI, TD0, SCL, UDI, SP, SNA, Z80, TAP, TZX, CSW, SZX, RZX |
|Windows|[**Unreal Speccy** v0.39](emul/US0.39.0/)| C++ [git v0.37](https://github.com/mkoloberdin/unrealspeccy) [snapshot v0.39](http://dlcorp.nedopc.com/viewforum.php?f=27)|2019| SMT, Dexus, Alone Coder, Deathsoft | TRD, FDI, TD0, SCL, UDI, SP, SNA, Z80, TAP, TZX, CSW | 
|Crossplatform|[**Fuse** v1.5.7 linux](linux-fuse.sh) and [win32](emul/fuse-1.5.7-win32/)| C++ [snapshot v1.5.7](emul/src/fuse-1.5.7.tar.gz) from [git](http://fuse-emulator.sourceforge.net/#Source) |2018| [Fuse Team](http://fuse-emulator.sourceforge.net) | Z80, SNA, SZX, PZX, TAP, TZX, DSK, UDI, FDI, TD0, MGT, IMG, D40, D80, SAD, TRD, SCL, OPD |
|Crossplatform|[**JVGS** v1.1.4](emul/jVGS/)|JavaScript *WANTED*|2016| [Epsiloncool](https://viva-games.ru/) | TRD, SCL, TAP, TZX, Z80, ROM |
|Crossplatform|[**Qaop/JS** v1.4](emul/QAOP/)|JavaScript *WANTED*|2012| [Jan Bobrowski](https://torinak.com/qaop) | TAP, Z80, SNA, ROM, SCR |
|DOS| [**x128** v0.94](emul/X128_094) | C++ [snapshot](emul/src/X128) | 2002 | James McKay | TRD, FDI, FDD, SCL, Z80, SNA, SLT, VOC, TZX, BLX |
|DOS| [**r80** v0.30](emul/R80V030) | C++ *WANTED* | 2000 | Raul Gomez Sanchez | TRD, FDI, TAP, SNA, Z80, TZX, SLT, SCL  |
|DOS| [**Spectrum 128K** v3.05](emul/SHAL305) | C++ [snapshot](emul/src/SHAL305)| 1999 | Nikolay Shalaev | TRD, FDI, TD0 TAP, TZX  |


### ZXBOX VM

ZXBOX is an Ubuntu 20.04 Virtualbox VM with preinstalled emulators and over 10Gb of ZX Spectrum software.

[Download ZXBOX](https://app.vagrantup.com/reefactor/boxes/ZXBOX) VM from vagrant cloud or [build from sources](zxbox/build_zxbox.sh).

Ubuntu has enabled autologin with default vagrant user `vagrant` with password `vagrant`


##### ZXBOX VM contents

* Unreal Speccy Portable emulator [compiled from sources](zxbox/install_zxbox_ubuntu2004.sh)
* Fuse emulator + ROMs pack
* Wine (to run [Unreal Speccy v0.39 for Windows](emul/US0.39.0/))
* DOSBOX (to run X128, r80 and Shalaev emulators)
* over [8Gb of ZX Spectrum software - TOSEC-2021-repack filelist](zxbox/TOSEC-2021-repack-fileslist.txt) collection based on [TOSEC 2021 release](https://www.tosecdev.org/news/releases/167-tosec-release-2021-02-14) repacked and released by [ladyeklipse](https://sourceforge.net/u/ladyeklipse/profile)
* over 4Gb of ZX Spectrum software - Virtual TRDOS (DVD 1.7 2007) collection from https://vtrd.in/
* Double Commander and Midnight Commander for fast-and-old-school navigation


##### Nested emulation layers structure
| Layer #3 - Z80 Emulation | USP, Fuse  | Unreal Speccy | x128, r80, Shalaev |
|:---| :---: |---|:---:|
| Layer #2 - Crossplatform |  |  [wine](https://www.winehq.org/) (Windows on Linux) | [dosbox](https://www.dosbox.com/) (MSDOS on Linux) |
| Layer #1 - Common VM OS | -//- | Ubuntu 20.04 Desktop | -//- |
| HOST OS - VirtualBox | -//- | any [OS capable of running VirtualBox](https://www.virtualbox.org/manual/ch01.html#hostossupport)   | -//- |



### HOWTO Start

#### Any platform

Open in web browser [jVGS](emul/jVGS/jvgs-offline.html) or use command line [jvgs.sh](jvgs.sh)) or [Qaop](emul/QAOP/qaop.html#ay#128).

Then open image from your local file system.
(with Google Chrome use `google-chrome --allow-file-access-from-files`)


#### Linux

Build from sources and start Unreal Speccy Portable
```bash
linux-usp.sh
```

Install from packages and start Fuse
```bash
linux-fuse.sh
```

Start UnrealSpeccy with wine
```bash
wine-unrealspeccy.sh
```

#### Windows

Start UnrealSpeccy
```
win-unrealspeccy.bat
```

#### DOS or any OS that has [dosbox](https://www.dosbox.com/download.php?main=1) emulation layer

Start r80 via dosbox
```
dosbox-r80.sh
```

Start Shalaev via dosbox
```
dosbox-shalaev.sh
```

Start x128 via dosbox
```
dosbox-x128.sh
```

### Navigation hotkeys for common actions

|Action         |   Unreal Speccy |      USP |   Fuse           |r80|x128|Shalaev|
|---|------|---|---|---|---|---|
|Open image|  `F3`       |`Escape`/ Open| `F3`       |`F8`, `F4`|`F12`, `F5`|
|Reset          | `F12`, `Ctrl-F12`|  `F12` | `F5`      | `F2`| `F3`  | `F3`, `F4`|
|Hardware settings|`Shift-F4`, `Shift-F7`|  | `F9`, `F4`|`F2`, `F12`| `F3`,`F4`,`F11`, `Shift-F11`|    
|Exit              |    `Alt-F4`     | `Alt-F4` |   `F10` |`F10`|`F10`|`Escape`, `Alt-X`|
|Menu              |                   |  `Escape`| `F1`    | `F1`| `F1` | `Escape`|


#### USP notes

To [build from sources on debian linux](emul/build_UnrealSpeccyP_debian.sh):
```bash
sudo apt install cmake g++ libcurl4-openssl-dev libsdl2-dev

git clone https://bitbucket.org/djdron/unrealspeccyp.git usp
cd usp/build/cmake && mkdir build && cd build

cmake .. -DUSE_SDL2=ON -DUSE_SDL=OFF -DCMAKE_BUILD_TYPE=Release
make -j4

cp -r ../../../res .
./unreal_speccy_portable
```

Checkout `BROWSE WEB` option in Main Menu for huge online software catalog maintained by [vtrd.in](https://vtrd.in) community. 

UX NOTE: change `JOYSTICK` option from `KEMPSTON` to `CURSOR` in order to TRDOS menu to work


### CREDITS
* https://vtrd.in for Virtual TR-DOS archive and comunity
* http://dlcorp.nedopc.com for Unreal Speccy emulator
* https://viva-games.ru/ for jVGS emulator
* https://sourceforge.net/u/ladyeklipse/profile for largest collection
* https://www.worldofspectrum.org for the Mission
