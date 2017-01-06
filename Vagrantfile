# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider :virtualbox do |vb|
    # VirtualBox VM name
    vb.name = "mujin"
  end
  # BOX name
  config.vm.box = "debian/wheezy64"
  # BOX url
  config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/wheezy64"
  # VM boot timeout
  config.vm.boot_timeout = 360
  # Provisioning
  #config.vm.provision :shell, inline: $script

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "mujin"
  end
end
