#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: install_installer
#

# install some extra packages to make this work right.
case node['platform_family']
  when "debian"
    include_recipe "apt"
    include_recipe "gdebi"
  when "rhel"
    #
end

if platform_family?("debian")
  # get some high level variables
  Chef::Log.info "Installing OpenStudio via Installer"
  filename = "OpenStudio-#{node[:openstudio][:version]}.#{node[:openstudio][:installer][:version_revision]}-#{node[:openstudio][:installer][:platform]}.deb"
  file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
  Chef::Log.info "Path to openstudio download will be #{file_path}"
  src_path = "#{node[:openstudio][:installer][:download_url]}/#{node[:openstudio][:version]}/#{filename}"
  test_version = "#{node[:openstudio][:version]}.#{node[:openstudio][:installer][:version_revision]}"

  is_installed_command = "ruby -e \"require 'openstudio'\" -e \"puts OpenStudio::openStudioLongVersion\" | grep -q #{test_version}"
  openstudio_version = `ruby -e "require 'openstudio'" -e "puts OpenStudio::openStudioLongVersion"`
  Chef::Log.info("Current version of OpenStudio is #{openstudio_version} and requesting #{test_version} ")
  
  #check the current version of openstudio installation
  ruby_block "check-openstudio-version" do
    block do
      Chef::Log.info("Current version of OpenStudio is #{openstudio_version} and requesting #{test_version} ")
      Chef::Log.info("OpenStudio is installed command #{is_installed_command}")
    end
    notifies :create, "remote_file[#{file_path}]", :immediately
    notifies :install, "gdebi_package[openstudio]", :immediately
    notifies :run, "execute[symlink-openstudio-directories]", :immediately
    
    action :run
    not_if is_installed_command 
  end

  remote_file file_path do
    source src_path
    mode 00755
    action :nothing

    already_downloaded = File.exists?(file_path) && File.size?(file_path) > 0
    Chef::Log.info "OpenStudio already_downloaded set to #{already_downloaded}"
    not_if { already_downloaded }
  end

  # use gdebi to install dependencies
  gdebi_package "openstudio" do
    source file_path

    action :nothing
  end

  execute "symlink-openstudio-directories" do
    command "cd /usr/local/lib/ruby/site_ruby/2.0.0/ && ln -sf x86_64-linux lib"
    
    action :nothing
  end
else
  Chef::Log.warn("Installing from a #{node['platform_family']} installer is not yet not supported by this cookbook")
  # If working with RHEL/CENTOS then you need to install specific versions of boost and perhaps
  # other dependencies; however these dependencies are not available by packages and need to be compiled.
end




