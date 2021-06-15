#!/usr/bin/env bash
#
# Package ZXBOX into vagrant box for vagrant cloud upload
# https://app.vagrantup.com/reefactor/boxes/ZXBOX
#

set -xe
SCRIPTDIR=$(cd `dirname $0` && pwd)
pushd $SCRIPTDIR

vagrant halt
vagrant package --output zxbox.box
md5sum zxbox.box

# https://blog.ycshao.com/2017/09/16/how-to-upload-vagrant-box-to-vagrant-cloud/
# TODO automate upload script
# Creating Boxes with the API
# https://www.vagrantup.com/vagrant-cloud/boxes/create#creating-boxes-with-the-api
echo "Proceed with manual upload zxbox.box in https://app.vagrantup.com/reefactor/boxes/ZXBOX"
