# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://app.vagrantup.com/boxes/search
vmbox_image = ENV["VMBOX_IMAGE"] || "generic/ubuntu2004"


# Check required vagrant dependencies plugins and install them
required_plugins = %w( vagrant-reload vagrant-disksize vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    # restart vagrant to apply installed plugins
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure("2") do |config|

  config.vm.box = vmbox_image

  # enlarge your default disk size
  config.disksize.size = '16GB'

  # allow ssh access from host with pubkey
  id_rsa_ssh_key_pub = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))
  config.vm.provision :shell, :inline => "\
    echo '#{id_rsa_ssh_key_pub }' > /home/vagrant/.ssh/authorized_keys && chmod 600 /home/vagrant/.ssh/authorized_keys"

  # set defaults for VMs
  config.vm.provider 'virtualbox' do |vb|

    vb.name = "zx-spectrum-instapack-vbox"

    # enable native GUI window
    vb.gui = true

    # hardware specs
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--memory", 3000]

    # network
    vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
    vb.customize ['modifyvm', :id, "--natdnshostresolver1", "off"]

    # enable audio (none|dsound|oss|alsa|pulse|coreaudio: supported audio types depends on the host OS)
    vb.customize ["modifyvm", :id, "--audio", "pulse", "--audioout", "on", "--audiocontroller", "ac97"]

    # enable RDP GUI access
    vb.customize ["modifyvm", :id, "--vrde", "on", "--vrdemulticon", "on", "--vrdeport", "3389"]

    # solve issue 'stuck connection timeout retrying' (kernel selection menu)
    # https://stackoverflow.com/questions/22575261/vagrant-stuck-connection-timeout-retrying
    # reduce first-time boot long waiting (600 sec default timeout)
    config.vm.boot_timeout = 60
  end

  config.vm.define 'zxbox' do |vmbox|
    vmbox.vm.hostname = "zxbox"
    vmbox.vm.network "private_network", ip: "192.168.10.3"
  end

  # trigger reload after changing network
  config.vm.provision :reload
end
