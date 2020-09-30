#!/usr/bin/env bash
set -e
echo build UnrealSpeccyP from sources ..

SCRIPTDIR=$(cd `dirname $0` && pwd)
USP_DIR=$SCRIPTDIR/UnrealSpeccyP

mkdir -p $USP_DIR
cd $USP_DIR

if [ ! `which cmake` ]; then
  sudo apt-get install -y cmake g++ libcurl4-openssl-dev libsdl2-dev
fi

if [ -e UnrealSpeccyP ]; then
  rm -rf UnrealSpeccyP
fi

tar xf $SCRIPTDIR/src/UnrealSpeccyP-v0.0.86.12.tgz

cd UnrealSpeccyP/build/cmake && mkdir build && cd build
# for exotic cases add params: -DCMAKE_CXX_FLAGS="`sdl2-config --cflags`" -DCMAKE_EXE_LINKER_FLAGS="`sdl2-config --libs`"
cmake .. -DUSE_SDL2=ON -DUSE_SDL=OFF -DCMAKE_BUILD_TYPE=Release
make -j4

# put ROMs together with binary required to run
cp -r ../../../res $USP_DIR
cp ./unreal_speccy_portable $USP_DIR
cd $USP_DIR

# enjoy
echo enjoy!:\n\t $PWD/unreal_speccy_portable $1
# ./unreal_speccy_portable $1
