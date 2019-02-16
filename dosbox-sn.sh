#!/usr/bin/env bash

SCRIPTDIR=$(cd `dirname $0` && pwd)

if [ ! `which dosbox` ]; then
  echo "Installing dosbox emulator"
  sudo apt install -y dosbox
fi

dosbox -c "mount c $PWD" -c "c:" -c "SET PATH=%PATH%;C:\EMUL\SN112ALL" -c "SN.COM"
