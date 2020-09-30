#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)

url=$SCRIPTDIR/emul/jVGS/jvgs-offline.html

if [ `which python3` ]; then
  cd emul/jVGS
  python3 -m http.server 8000 &
  url=http://localhost:8000/jvgs-offline.html
fi

cd $SCRIPTDIR/ZX

if [ `which chromium-browser` ]; then
  chromium-browser $url
elif [ `which firefox` ]; then
  firefox $url
elif [ `which google-chrome` ]; then
  google-chrome $url
fi
