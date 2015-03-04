#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: install_installer
#

if platform_family?('debian')
  # install some extra packages to make this work right.
  include_recipe 'apt'
  package 'gdebi-core'

  # get some high level variables
  src_path = ''
  filename = ''
  case node[:openstudio][:installer][:origin]
  when 's3'
    Chef::Log.info 'Installing OpenStudio via Installer from s3'
    filename = "OpenStudio-#{node[:openstudio][:version]}.#{node[:openstudio][:installer][:version_revision]}-#{node[:openstudio][:installer][:platform]}.deb"
    src_path = "#{node[:openstudio][:installer][:download_url]}/#{node[:openstudio][:version]}/#{filename}"
  when 'developer'
    Chef::Log.info 'Installing OpenStudio via Installer from developer'
    filename = "OpenStudio-#{node[:openstudio][:version]}.#{node[:openstudio][:installer][:version_revision]}-#{node[:openstudio][:installer][:platform]}.deb"
    src_path = "#{node[:openstudio][:installer][:download_url]}/#{node[:openstudio][:version]}/#{filename}"
  when 'url'
    Chef::Log.info 'Installing OpenStudio via Installer from url'
    filename = node[:openstudio][:installer][:download_filename]
    src_path = "#{node[:openstudio][:installer][:download_url]}/#{node[:openstudio][:installer][:download_filename]}"
  end

  test_version = "#{node[:openstudio][:version]}.#{node[:openstudio][:installer][:version_revision]}"
  file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
  Chef::Log.info "Path to openstudio download will be #{file_path}"

  is_installed_command = "ruby -e \"require 'openstudio'\" -e \"puts OpenStudio::openStudioLongVersion\" | grep -q #{test_version}"
  openstudio_version = `ruby -e "require 'openstudio'" -e "puts OpenStudio::openStudioLongVersion"`
  Chef::Log.info("Current version of OpenStudio is #{openstudio_version} and requesting #{test_version} ")

  # check the current version of openstudio installation
  ruby_block 'check-openstudio-version' do
    block do
      Chef::Log.info("Current version of OpenStudio is #{openstudio_version} and requesting #{test_version} ")
      Chef::Log.info("OpenStudio is installed command #{is_installed_command}")
    end
    notifies :create, "remote_file[#{file_path}]", :immediately
    notifies :run, 'execute[openstudio]', :immediately
    notifies :run, 'execute[symlink-openstudio-directories]', :immediately

    action :run
    # not_if is_installed_command
  end

  remote_file file_path do
    source src_path
    mode 00755
    action :nothing

    already_downloaded = File.exist?(file_path) && File.size(file_path) > 0
    Chef::Log.info "OpenStudio already_downloaded set to #{already_downloaded}"
    not_if { already_downloaded }
  end

  execute 'openstudio' do
    command "gdebi -n -q #{file_path}"

    action :nothing
  end

  # This may no longer be needed in OpenStudio 1.5.1 or greater. Need to verify how this breaks older versions.
  execute 'symlink-openstudio-directories' do
    command 'cd /usr/local/lib/ruby/site_ruby/2.0.0/ && ln -sf x86_64-linux lib'

    action :nothing
    not_if { Chef::VersionConstraint.new('>= 1.5.1').include?(node[:openstudio][:version]) }
  end
else
  Chef::Log.warn("Installing from a #{node['platform_family']} installer is not yet not supported by this cookbook")
  # If working with RHEL/CENTOS then you need to install specific versions of boost and perhaps
  # other dependencies; however these dependencies are not available by packages and need to be compiled.
end
