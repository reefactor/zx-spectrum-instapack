#!/usr/bin/env bash
# build Virtualbox VM (see Vagrantfile)

set -e
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


# accept vm ssh key 
ssh -o StrictHostKeyChecking=no $TARGETHOST hostname

# deploy
install_path="/home/vagrant/zx-spectrum-instapack"
scp -rp $(realpath $SCRIPTDIR/../) $TARGETHOST:$install_path
# rsync ~/.cache/aria2/dht.dat $TARGETHOST:~/.cache/aria2/

# install
ssh $TARGETHOST "sudo bash $install_path/zxbox/install_zxbox_ubuntu2004.sh"

# cleanup
ssh $TARGETHOST "rm .ssh/authorized_keys"


echo "ZXBOX VM build complete."
echo "Proceed with tuning and upload with 'package_vagrant_box.sh'"
