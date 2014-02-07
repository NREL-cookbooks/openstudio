# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.hostname = "openstudio-vagrant"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-precise-64-vbox"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  #config.vm.box = "centos65-x86_64"
  #config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"

  config.vm.network :private_network, :ip => "33.33.33.35"

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024, "--cpus", 2]

    # Disable DNS proxy.
    # Causes slowness: https://github.com/rubygems/rubygems/issues/513
    #vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "../"

    chef.add_recipe("recipe[ruby_build]")
    chef.add_recipe("recipe[rbenv::system]")
    chef.add_recipe("openstudio::default")
    chef.json = {
        :rbenv => {
            :upgrade => true,
            :rubies => [
                {
                    :name => '2.0.0-p353',
                    :environment => {
                        'RUBY_CONFIGURE_OPTS' => '--enable-shared', # needs to be set for openstudio linking
                        'CONFIGURE_OPTS' => '--disable-install-doc'
                    }
                }
            ],
            :no_rdoc_ri => true,
            :global => "2.0.0-p353",
            :gems => {
                "2.0.0-p353" => [
                    {
                        :name => "bundler",
                        :version => "1.3.5"
                    }
                ]
            }
        }
    }

  end
end




