# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "lattice/ubuntu-trusty-64"
  config.vm.provision :shell, path: "Vagrantdata/bootstrap.sh"
  config.vm.network "private_network", ip:"192.168.50.4"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provider "vmware_fusion" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end

