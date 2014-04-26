# Rakefile to help build OpenStudio on a remote target and download the binaries locally

# Style tests. Rubocop and Foodcritic
namespace :build do
  def files_to_download
    files = [
        {
            remote: '/usr/local/openstudio-*/build.log',
            local: '.'
        },
        {
            remote: '/usr/local/openstudio-*/OpenStudio-*.tar.gz',
            local: '.'
        }
    ]
    files
  end

  desc 'Download the built binaries from Vagrant'
  task :download_vagrant do

    # save the vagrant ssh config file
    ssh_config_file = './vagrant.ssh.config'
    File.delete(ssh_config_file) if File.exists?(ssh_config_file)
    `vagrant ssh-config > #{ssh_config_file}`

    files_to_download.each do |f|
      `scp -F vagrant.ssh.config default:#{f[:remote]} #{f[:local]}`
    end
  end

  desc 'Download the built binaries from Kitchen'
  task :download_kitchen do
    require 'yaml'
    require 'pp'
    files = [
        {
            remote: '/usr/local/openstudio-*/build.log',
            local: '.'
        },
        {
            remote: '/usr/local/openstudio-*/OpenStudio-*.tar.gz',
            local: '.'
        }
    ]

    # get kitchen yml files
    configs = Dir.glob('.kitchen/*.yml')
    File.exist?('.kitchen.yml') ? k_yml = YAML.load_file('.kitchen.yml') : k_yml = nil
    if k_yml
      configs.each do |configfile|
        current_platform = File.basename(configfile, '.yml')
        pp "Platform from YML file is: #{current_platform}"

        # Find the section in the kitchen.yml file that has the platform define to get the key and username
        platform = nil
        k_yml['platforms'].each do |p|
          if p['name'].gsub('.', '') == current_platform.gsub('build-', '')
            platform = p
            break
          end
        end

        fail "no platform found for #{current_platform}" unless platform

        config = YAML.load_file(configfile)
        files_to_download.each do |f|
          pp "Trying to download #{f[:remote]}"
          `scp -o StrictHostKeyChecking=no -i #{File.expand_path("~/.ssh/#{ENV['AWS_SSH_KEY_ID']}")} \
          #{platform['driver']['username']}@#{config['hostname']}:#{f[:remote]} #{f[:local]}`
        end
      end
    else
      puts "No kitchen.yml configuration file found"
    end
  end
end
