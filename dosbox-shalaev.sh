#!/usr/bin/env bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

if [ ! `which dosbox` ]; then
  echo "Installing dosbox emulator"
  sudo apt install -y dosbox
fi

dosbox  -c "mount c $SCRIPTDIR" -c "c:" -c "cd C:\EMUL\SHAL305" -c keyrus -c SPECTRUM.EXE -c exit

