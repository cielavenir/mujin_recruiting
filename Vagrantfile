# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  vmname = 'mujin'
  # BOX name and url
  if ENV['MUJIN_RECRUITING']=='focal'
    #vmname = 'buster'
    config.vm.box = "ubuntu/focal64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/focal64"
  elsif ENV['MUJIN_RECRUITING']=='bionic'
    #vmname = 'buster'
    config.vm.box = "ubuntu/bionic64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/bionic64"
  elsif ENV['MUJIN_RECRUITING']=='xenial'
    config.vm.box = "ubuntu/xenial64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/xenial64"
  elsif ENV['MUJIN_RECRUITING']=='buster'
    #vmname = 'buster'
    config.vm.box = "debian/buster64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/buster64"
  elsif ENV['MUJIN_RECRUITING']=='stretch'
    config.vm.box = "debian/stretch64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/stretch64"
  else
    config.vm.box = "debian/jessie64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/jessie64"
  end

  config.vm.provider :virtualbox do |vb|
    # VirtualBox VM name
    vb.name = vmname
    vb.customize ["modifyvm", :id, "--memory", "5120", "--cpus", "4"]
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
