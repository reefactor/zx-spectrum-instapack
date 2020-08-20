
# ZX-SPECTRUM instant all-in pack

Launch scripts for preconfigured collection of best emulators, roms and zx software.
All you need to [spend time](overboot.asm) on a desert island.

### Instant Speccy with OS-agnostic Javascript-based emulators 

* [**jVGS** v1.1.4](https://reefactor.github.io/zx-spectrum-instapack/emul/jVGS/jvgs-offline.html) by [Epsiloncool](https://viva-games.ru/) adapted to run images from local file system

* [**Qaop/JS** v1.4](https://reefactor.github.io/zx-spectrum-instapack/emul/QAOP/qaop.html#ay#128) by [Jan Bobrowski](https://torinak.com/qaop) runs on Firefox and Chrome (use `google-chrome --allow-file-access-from-files`).  
Last updated circa 2012. Great but has no Betadisk128 (TRD, FDI) support.


### Best ZX-SPECTRUM emulators

|Host OS|Emulator| Source code |Last updated|
|---|---|---|---|
|Crossplatform|[**JVGS** v1.1.4](https://viva-games.ru/jvgs/jvgsc.min.js)|JavaScript *WANTED*|2016|
|Windows|[**Unreal Speccy** v0.39](https://github.com/mkoloberdin/unrealspeccy)| C++ [git v0.37](https://github.com/mkoloberdin/unrealspeccy) [snapshot v0.39](http://dlcorp.nedopc.com/viewforum.php?f=27)|2019|
|Crossplatform|[**USP** v0.38 - Unreal Speccy Portable fork](https://bitbucket.org/djdron/unrealspeccyp)| C++ [git](https://bitbucket.org/djdron/unrealspeccyp)|2018|
|Crossplatform|[**Fuse** emulator v1.5.7](http://fuse-emulator.sourceforge.net)| C++ [git](http://fuse-emulator.sourceforge.net/#Source)|2018|
|DOS| [**x128** v0.94 by James McKay](emul/X128_094) | C++ [snapshot](emul/src/X128) | 2002 |
|DOS| [**r80** v0.30 by Raul Gomez Sanchez](emul/R80V030) | C++ *WANTED* | 2000 |
|DOS| [**Spectrum 128K** v3.05 by Nikolay Shalaev](emul/SHAL305) | C++ [snapshot](emul/src/SHAL305)| 1999 |


### Launchers

#### Anywhere

Just [open jVGS in your browser](emul/jVGS/jvgs-offline.html) (see launch script [jvgs.sh](jvgs.sh))


#### Linux

Build and start USP
```bash
linux-usp.sh
```

Install and start Fuse
```bash
linux-fuse.sh
```

Start unrealspeccy via wine
```bash
wine-unrealspeccy.sh
```

#### Windows
```
win-unrealspeccy.bat
```

#### DOS or any OS that has [dosbox](https://www.dosbox.com/download.php?main=1) emulation layer

Start r80 via dosbox
```
dosbox-r80.sh
```

Start shalaev via dosbox
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

To [build from sources on debian linux](emul/build_usp_debian-ubuntu.sh):
```bash
sudo apt install cmake g++ libcurl4-openssl-dev libsdl2-dev

git clone https://bitbucket.org/djdron/unrealspeccyp.git usp
cd usp/build/cmake && mkdir build && cd build

cmake .. -DUSE_SDL2=ON -DUSE_SDL=OFF -DCMAKE_BUILD_TYPE=Release
make -j4

cp -r ../../../res .
./unreal_speccy_portable
```

Checkout `BROWSE WEB` option in Main Menu. 
Huge online catalog is maintained by [vtrd.in](https://vtrd.in) community. 

UX NOTE: change `JOYSTICK` option from `KEMPSTON` to `CURSOR` in order to TRDOS menu to work


### CREDITS
* https://vtrd.in
* http://dlcorp.nedopc.com
* http://www.zxspectrum.net
* http://www.worldofspectrum.org
