# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "openstudio-berkshelf"
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
  #config.vm.box = "centos64-nrel-x86_64"
  #config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"

  config.vm.network :private_network, type: "dhcp"
  config.vm.provider :virtualbox do |p|
    nc = 3
    p.customize ["modifyvm", :id, "--memory", nc*2048, "--cpus", nc]
  end

  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.json = {
	:openstudio => {
		:install_method => "source",
		:installer => {
			:version => "1.3.2",
			:version_revision => "386caf0e00"
		}
	}
    }

    chef.run_list = [
        "recipe[openstudio::default]"
    ]
  end
end
