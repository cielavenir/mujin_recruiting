# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider :virtualbox do |vb|
    # VirtualBox VM name
    vb.name = "mujin"
    vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "4"]
  end
  if ENV['MUJIN_RECRUITING_UBUNTU'] && ENV['MUJIN_RECRUITING_UBUNTU']!='' && ENV['MUJIN_RECRUITING_UBUNTU']!='0'
    # BOX name and url
    config.vm.box = "ubuntu/xenial64"
    config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64"
  else
    # BOX name and url
    config.vm.box = "debian/jessie64"
    config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64"
  end
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
