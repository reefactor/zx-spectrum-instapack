#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)
cd $SCRIPTDIR/ZX

jvgs=$SCRIPTDIR/emul/jVGS/jvgs-offline.html

if [ `which chromium-browser` ]; then
  chromium-browser $jvgs
elif [ `which firefox` ]; then
  firefox $jvgs
elif [ `which google-chrome` ]; then
  google-chrome $jvgs
fi
