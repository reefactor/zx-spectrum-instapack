#!/usr/bin/env bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

if [ ! `which dosbox` ]; then
  echo "Installing dosbox emulator"
  sudo apt install -y dosbox
fi

dosbox  -c "mount c $SCRIPTDIR" -c "c:" -c "cd c:\emul\r80v030" -c "r80.exe" -c exit

