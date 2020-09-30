#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)

if [ `which unreal-speccy-portable` ]; then
  # found in system
  unreal-speccy-portable $SCRIPTDIR/ZX/
else
  # build from sources
  localusp=$SCRIPTDIR/emul/UnrealSpeccyP/unreal_speccy_portable
  if [ ! -f $localusp ]; then
    bash $SCRIPTDIR/emul/build_UnrealSpeccyP_debian.sh
  fi

  # run local build
  cd `dirname $localusp`
  $localusp $SCRIPTDIR/ZX/
fi
