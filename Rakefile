# Rakefile to help build OpenStudio on a remote target and download the binaries locally

# Style tests. Rubocop and Foodcritic
namespace :build do
  desc 'Download the built binaries from Vagrant'
  task :download do

    # save the vagrant config file
    current_dir = File.dirname(__FILE__)
    Dir.chdir(current_dir)
    ssh_config_file = './vagrant.ssh.config'
    File.delete(ssh_config_file) if File.exists?(ssh_config_file)
    `vagrant ssh-config > #{ssh_config_file}`

    # todo: determine the right version
    remote_file = '/usr/local/openstudio-v1.3.2/build.log'
    local_path = '.'
    `scp -F vagrant.ssh.config default:#{remote_file} #{local_path}`

    remote_file = '/usr/local/openstudio-v1.3.2/OpenStudio-*.tar.gz'
    local_path = '.'
    `scp -F vagrant.ssh.config default:#{remote_file} #{local_path}`
  end
end
