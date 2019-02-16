#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)
cd $SCRIPTDIR/ZX

if [ ! `which wine` ]; then
  printf "Installing wine \n"
  sudo apt install -y wine64
fi

wine $SCRIPTDIR/emul/US0.39.0/unreal.exe
