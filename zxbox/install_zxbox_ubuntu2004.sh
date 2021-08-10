#!/usr/bin/env bash
set -xe
SCRIPTDIR=$(cd `dirname $0` && pwd)
INSTAPACKDIR=$(realpath $SCRIPTDIR/../)

apt-get update
apt-get -y upgrade

# enable autologin
mv /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
echo "[daemon]" > /etc/gdm3/custom.conf
echo "AutomaticLoginEnable = true" >> /etc/gdm3/custom.conf
echo "AutomaticLogin = vagrant" >> /etc/gdm3/custom.conf

# for files browsing
apt-get install -y doublecmd-qt mc

# for git history browsing
apt-get install -y git tig

# dosbox & wine emulation
apt-get install -y dosbox wine libgles2-mesa
dpkg --add-architecture i386 && sudo apt-get update -y && sudo apt-get install -y wine32


# Fuse spectrum emulator
apt-get install -y fuse-emulator-sdl fuse-emulator-utils spectrum-roms
cp $INSTAPACKDIR/emul/src/fuse-roms-extra/* /usr/share/spectrum-roms/


# build Unreal Speccy Portable from sources
bash $INSTAPACKDIR/emul/build_UnrealSpeccyP_debian.sh


# create shortcuts
# TODO FIX Ubuntu "Allow Launching" property of shortcuts
cp $SCRIPTDIR/*.desktop /home/vagrant/Desktop
ln -sf $INSTAPACKDIR /home/vagrant/Desktop


if [ "$UBUNTU_STAMP" == "F2E5A9D993231708991919397871588" ]; then
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


# replace wallpaper
cp -r $SCRIPTDIR/wallpapers/* /home/vagrant/Pictures/
su vagrant sh -c 'dbus-launch gsettings set org.gnome.desktop.background picture-uri file:///home/vagrant/Pictures/ZX-Spectrum-ispolnilos-35-let.jpg'


echo Download ZX Spectrum software archives
sudo apt-get install -y aria2
cd $INSTAPACKDIR/ZX

echo Download and unpack largest software collection ZX Spectrum TOSEC Set v2020-02-18 [Lady Eklipse]
# for download use either rtorrent or aria2c or transmission-cli
aria2c --seed-time=0 'magnet:?xt=urn:btih:CF65C5792BA317E4E3D55FD49757B19CD21BF6D8&tr=http%3A%2F%2Fbt3.t-ru.org%2Fann%3Fmagnet&dn=%5BZX%20Spectrum%5D%20%5B%D0%A1%D0%B1%D0%BE%D1%80%D0%BD%D0%B8%D0%BA%5D%20%D0%9F%D0%BE%D0%BB%D0%BD%D0%B0%D1%8F%20%D0%BA%D0%BE%D0%BB%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F%20%D0%BD%D0%B0%20%D0%BE%D1%81%D0%BD%D0%BE%D0%B2%D0%B5%20TOSEC%20%5BP%5D%20(1982%E2%80%942021)%20(2021-02-18)'
cd "ZX Spectrum TOSEC"*
set +e  # accept unzipping with warnings
unzip '*.zip'
set -e
rm *.zip

echo Download Virtual TR-DOS DVD version 1.7
aria2c --seed-time=0 'magnet:?xt=urn:btih:C64A5B6645C6D742AB866CA94E829DAEE6DC119F&tr=http%3A%2F%2Fbt4.t-ru.org%2Fann%3Fmagnet&dn=%5BZX%20Spectrum%5D%20%5B%D0%A1%D0%B1%D0%BE%D1%80%D0%BD%D0%B8%D0%BA%5D%20Virtual%20TR-DOS%20DVD%20version%201.7'
echo unpack dvd iso image
iso_mount_path=/tmp/VTRDOS-DVD
mkdir $iso_mount_path
mount "$PWD/vt dvd 1.7.iso" $iso_mount_path -o loop
cp -rp $iso_mount_path .
chown -R vagrant VTRDOS-DVD
chmod -R u+w VTRDOS-DVD
umount $iso_mount_path
rm "$PWD/vt dvd 1.7.iso"
