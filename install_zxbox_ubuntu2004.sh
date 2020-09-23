#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)

apt-get update
apt-get install -y xinit

# enable autologin
mv /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
echo "[daemon]" > /etc/gdm3/custom.conf
echo "AutomaticLoginEnable = true" >> /etc/gdm3/custom.conf
echo "AutomaticLogin = vagrant" >> /etc/gdm3/custom.conf


apt-get install -y dosbox wine libgles2-mesa

apt-get install -y fuse-emulator-sdl


# build from sources
mv $SCRIPTDIR/emul/usp $SCRIPTDIR/emul/usp.old
bash $SCRIPTDIR/emul/build_usp_debian-ubuntu.sh


# after install xinit boot into gui logon
reboot
