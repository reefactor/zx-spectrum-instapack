#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)

# printf "Installing unreal-speccy-portable emulator https://bitbucket.org/djdron/unrealspeccyp/downloads/ \n"
# sudo apt install -y libcurl3
# sudo dpkg -i $SCRIPTDIR/emul/unreal-speccy-portable_0.0.83_amd64.deb

if [ `which unreal-speccy-portable` ]; then
  unreal-speccy-portable $SCRIPTDIR/ZX/
else
  localusp=$SCRIPTDIR/emul/usp/unreal_speccy_portable
  if [ -f $localusp ]; then
    cd `dirname $localusp`
    ./unreal_speccy_portable $SCRIPTDIR/ZX/
  else
    bash $SCRIPTDIR/emul/build_usp_debian-ubuntu.sh $SCRIPTDIR/ZX/
  fi
fi
