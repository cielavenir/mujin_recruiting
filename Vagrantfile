# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider :virtualbox do |vb|
    # VirtualBox VM name
    vb.name = "mujin"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  # BOX name
  config.vm.box = "debian/jessie64"
  # BOX url
  config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64"
  # VM boot timeout
  config.vm.boot_timeout = 360
  # Provisioning
  #config.vm.provision :shell, inline: $script

  #config.vm.provision :chef_solo do |chef|
  #  chef.cookbooks_path = "cookbooks"
  #  chef.add_recipe "mujin"
  #end
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 8080, host: 8080
end
