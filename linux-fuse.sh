#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)
cd $SCRIPTDIR/ZX

if [ ! `which fuse-sdl` ]; then
  echo "Installing fuse-emulator-sdl emulator"
  sudo apt install -y fuse-emulator-sdl
fi

fuse-sdl --machine pentagon --graphics-filter 3x --kempston-mouse
