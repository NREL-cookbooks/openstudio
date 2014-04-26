# Rakefile to help build OpenStudio on a remote target and download the binaries locally
require 'kitchen'
require 'pp'
require 'yaml'

namespace :build do
  def files_to_download
    files = [
        {remote: '/usr/local/openstudio-*/build.log', local: '.'},
        {remote: '/usr/local/openstudio-*/OpenStudio-*.tar.gz', local: '.'}
    ]
  end

  # Download the files off of the machines (either vagrant or kitchen)
  def download_files(instance)
    if instance.driver.name.downcase == 'vagrant'
      # save the vagrant ssh config file
      ssh_config_file = './vagrant.ssh.config'
      File.delete(ssh_config_file) if File.exists?(ssh_config_file)
      `vagrant ssh-config > #{ssh_config_file}`

      files_to_download.each do |f|
        `scp -F vagrant.ssh.config default:#{f[:remote]} #{f[:local]}`
      end
    elsif instance.driver.name.downcase == 'ec2'
      # look for the .kitchen/xyz.yml file
      instance_file = "./kitchen/#{instance.name}.yml"
      if File.exist?(instance_file)
        config = YAML.load_file(instance_file)

        files_to_download.each do |f|
          pp "Trying to download #{f[:remote]}"
          `scp -o StrictHostKeyChecking=no -i #{instance.driver[:ssh_key]} \
          #{platform['driver']['username']}@#{config['hostname']}:#{f[:remote]} #{f[:local]}`
        end
      end
    end
  end

  desc 'Build OpenStudio'
  task :kitchen do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|

      # right now only build amazon ubuntu version
      if instance.suite.name == 'build-ruby-200' && instance.platform.name == 'aws-ubuntu-1204'
        begin
          pp instance.provisioner[:attributes]
          instance.test(:none) # don't destroy the instance until laster

          # download the data
          download_files(instance)
        ensure
          instance.destroy
        end
      end
    end
  end
end
