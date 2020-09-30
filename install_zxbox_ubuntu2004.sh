#!/usr/bin/env bash
SCRIPTDIR=$(cd `dirname $0` && pwd)

apt-get update

# enable autologin
mv /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
echo "[daemon]" > /etc/gdm3/custom.conf
echo "AutomaticLoginEnable = true" >> /etc/gdm3/custom.conf
echo "AutomaticLogin = vagrant" >> /etc/gdm3/custom.conf


apt-get install -y dosbox wine libgles2-mesa
dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32

apt-get install -y fuse-emulator-sdl


# build from sources
bash $SCRIPTDIR/emul/build_UnrealSpeccyP_debian.sh

# create shortcuts to lunch emulators
ln -s $SCRIPTDIR /home/vagrant/Desktop
cp $SCRIPTDIR/usp.desktop /home/vagrant/Desktop/


if [ -e $FROM_UBUNTUS_ERVER ]; then
  # make ubuntu desktop from ubuntu server
  apt-get install -y xinit
  apt-get install -y gnome-panel gnome-tweaks
  # add Nemo default file manager in Ubuntu
  apt-get install -y nemo
  xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
  gsettings set org.gnome.desktop.background show-desktop-icons false
  gsettings set org.nemo.desktop show-desktop-icons true
  # after install xinit boot into gui logon
  reboot
fi
