# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.hostname = "openstudio-build"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-precise-64-vbox"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  #config.vm.box = "centos65-x86_64-nrel"
  #config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140110.box"

  config.vm.network :private_network, :ip => "33.33.33.35"

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 4096, "--cpus", 4]

    # Disable DNS proxy.
    # Causes slowness: https://github.com/rubygems/rubygems/issues/513
    #vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  config.vm.provider :aws do |aws, override|
    begin
      override.vm.box = "dummy"
      override.vm.box_url = "http://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

      # you will need to create a yaml file with these values to
      # properly deploy to ec2
      require 'yaml'
      secret_file = File.join(Dir.home, ".aws_secrets")
      if File.exist? secret_file
        aws_config = YAML::load_file(secret_file)
        aws.access_key_id = aws_config.fetch("access_key_id")
        aws.secret_access_key = aws_config.fetch("secret_access_key")
        aws.keypair_name = aws_config.fetch("keypair_name")
        override.ssh.private_key_path = aws_config.fetch("private_key_path")
      else
        raise "Could not find '#{secret_file}' file with your secrets"
      end

      aws.security_groups = ["default"]
      aws.region = "us-east-1"
      aws.instance_type = "m3.xlarge" # $0.45 / hour, 4 cores, moderate network
      #aws.instance_type = "m3.2xlarge" # 8 cores
      #aws.instance_type = "t1.micro" # $0.45 / hour, 4 cores, moderate network
      #aws.ami = "ami-995a06f0"  # Ubuntu 12.04 x86_64 16GB version 
      #override.ssh.username = "ubuntu" 
      
      aws.ami = "ami-eb6b0182"  # CentOS 6.5 x86_64
      override.ssh.username = "root" 
      override.ssh.pty = true  # needed for centos
      


      aws.tags = {
          'Name' => 'build-openstudio',
          'UserUUID' => ENV["VAGRANT_AWS_USER_UUID"] || 'unknown_user_uuid'
      }
    rescue LoadError
      warn "Unable to configure AWS provider."
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "../"

    chef.add_recipe("recipe[apt]")
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
        },
        :openstudio => {
            :install_method => "source"
        }
    }

  end
end




