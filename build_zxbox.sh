#!/usr/bin/env bash
# build Virtualbox VM (see Vagrantfile)
# Usage:
#   ./build_zxbox.sh
#
set -xe
SCRIPTDIR=$(cd `dirname $0` && pwd)
pushd $SCRIPTDIR

if [[ $TARGETHOST == "" ]]; then
  TARGETHOST=vagrant@192.168.10.3
  set +e
  vagrant destroy -f;
  vagrant up; vagrant up
  ssh-keygen -f $HOME/.ssh/known_hosts -R 192.168.10.3
  set -e
fi

# test connection and remember ssh key
ssh -o StrictHostKeyChecking=no $TARGETHOST hostname


ssh $TARGETHOST "rm -rf ~/instapack"
scp -rp $SCRIPTDIR $TARGETHOST:~/instapack
set +e
ssh $TARGETHOST "sudo bash ~/instapack/install_zxbox_ubuntu2004.sh"
set -e
