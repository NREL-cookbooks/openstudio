# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'openstudio-berkshelf'

  # Don't use 11.14.2 because of https://github.com/opscode/chef/issues/1739 (duplicate error)
  config.omnibus.chef_version = 'latest'

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'ubuntu/trusty64'

  # Use berkshelf.  Make sure to install ChefDK if you are using Windows.
  config.berkshelf.enabled = true

  config.vm.network :private_network, type: 'dhcp'
  config.vm.provider :virtualbox do |p|
    nc = 3
    p.customize ['modifyvm', :id, '--memory', nc * 2048, '--cpus', nc]
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      openstudio: {
        # 1.5.1.0c740efe7c
        # 1.5.5.f6ccda50f0
	# 1.6.0.9ebfb81bd3
        version: '1.6.0',
        install_method: 'installer',
        installer: {
          version_revision: '9ebfb81bd3'
        }
      }
    }

    chef.run_list = [
      'recipe[openstudio::default]'
    ]
  end
end
