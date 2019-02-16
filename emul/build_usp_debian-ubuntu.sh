#!/usr/bin/env bash
set -e
echo build USP from sources ..

SCRIPTDIR=$(cd `dirname $0` && pwd)
USP_DIR=$SCRIPTDIR/usp

mkdir -p $USP_DIR
cd $USP_DIR

sudo apt install -y cmake g++ libcurl4-openssl-dev libsdl2-dev

# git clone https://bitbucket.org/djdron/unrealspeccyp.git usp
tar xf $SCRIPTDIR/src/usp-0.83-master-2018.tgz usp

cd usp/build/cmake && mkdir build && cd build
# for exotic cases add params: -DCMAKE_CXX_FLAGS="`sdl2-config --cflags`" -DCMAKE_EXE_LINKER_FLAGS="`sdl2-config --libs`"
cmake .. -DUSE_SDL2=ON -DUSE_SDL=OFF -DCMAKE_BUILD_TYPE=Release
make -j4

# put ROMs together with binary required to run
cp -r ../../../res $USP_DIR
cp ./unreal_speccy_portable $USP_DIR
cd $USP_DIR

# enjoy
./unreal_speccy_portable $1
