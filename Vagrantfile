# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  vmname = 'mujin'
  vmname = 'python3' if ENV['MUJIN_PYTHON3']
  vmname = 'clang' if ENV['MUJIN_CLANG']

  # BOX name and url
  if ENV['MUJIN_RECRUITING']=='jammy'
    config.vm.box = "ubuntu/jammy64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/jammy64"
  elsif ENV['MUJIN_RECRUITING']=='focal'
    config.vm.box = "ubuntu/focal64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/focal64"
  elsif ENV['MUJIN_RECRUITING']=='bionic'
    config.vm.box = "ubuntu/bionic64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/bionic64"
  elsif ENV['MUJIN_RECRUITING']=='xenial'
    config.vm.box = "ubuntu/xenial64"
    config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/xenial64"
  elsif ENV['MUJIN_RECRUITING']=='bookworm'
    config.vm.box = "debian/bookworm64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/bookworm64"
  elsif ENV['MUJIN_RECRUITING']=='bullseye'
    config.vm.box = "debian/bullseye64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/bullseye64"
  elsif ENV['MUJIN_RECRUITING']=='buster'
    config.vm.box = "debian/buster64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/buster64"
  elsif ENV['MUJIN_RECRUITING']=='stretch'
    config.vm.box = "debian/stretch64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/stretch64"
  elsif ENV['MUJIN_RECRUITING']=='jessie'
    config.vm.box = "debian/jessie64"
    config.vm.box_url = "https://app.vagrantup.com/debian/boxes/jessie64"
  elsif ['up', 'destroy'].include?(ARGV[0])
    raise 'MUJIN_RECRUITING=[jammy|focal|bionic|xenial|bullseye|buster|stretch|jessie] [MUJIN_PYTHON3=1] [MUJIN_CLANG=1] vagrant up'
  end

  config.vm.provider :virtualbox do |vb|
    # VirtualBox VM name
    vb.name = vmname
    vb.customize ["modifyvm", :id, "--memory", (8*1024).to_s, "--cpus", "4"]
  end

  # VM boot timeout
  config.vm.boot_timeout = 360
  # Provisioning
  #config.vm.provision :shell, inline: $script

  #config.vm.provision :chef_solo do |chef|
  #  chef.cookbooks_path = "cookbooks"
  #  chef.add_recipe vmname
  #end
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 8080, host: 8080
end
