#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: install_installer
#

# install some extra packages to make this work right.
case node['platform_family']
  when "debian"
    include_recipe "apt"
    package "libgl1-mesa-glx"
  when "rhel"
    include_recipe "yum"
end

if platform_family?("debian")
  Chef::Log.info "Installing OpenStudio via Installer"
  filename = "OpenStudio-#{node[:openstudio][:installer][:version]}.#{node[:openstudio][:installer][:version_revision]}-#{node[:openstudio][:installer][:platform]}.deb"
  file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
  Chef::Log.info "Path to openstudio download is #{file_path}"
  src_path = "#{node[:openstudio][:installer][:download_url]}/#{node[:openstudio][:installer][:version]}/#{filename}"

  remote_file file_path do
    source src_path
    mode 00755
    action :create
    
    already_downloaded = File.exists?(file_path) && File.size?(file_path)
    not_if { already_downloaded }
    
    notifies :install, "package[openstudio]", :immediately
  end

  #ruby_block "check-openstudio-version" do
  #  Chef::Log.info("OpenStudio version installed is set to #{version_installed}")
  #  version_installed = false
  #  if File.exists?("/usr/local/lib/ruby/site_ruby/2.0.0/openstudio.rb")
  #    # check the version
  #    version = `ruby -I /usr/local/lib/ruby/site_ruby/2.0.0/ -e "require 'openstudio'" -e "puts OpenStudio::openStudioLongVersion"`.chomp
  #    Chef::Log.info("Current version of OpenStudio is #{version} and requesting #{node[:openstudio][:installer][:version]}.#{node[:openstudio][:installer][:version_revision]}")
  #    if "#{node[:openstudio][:installer][:version]}.#{node[:openstudio][:installer][:version_revision]}".include?(version)
  #      version_installed = true
  #    end
  #  end
  #  
  #  not_if { version_installed }
  #  notifies :install, "package[openstudio]", :immediately 
  #end
  
  #not_if { version_installed }
  
  package "openstudio" do
    source file_path
    notifies :run, "execute[install-openstudio-deps]", :immediately
    notifies :run, "execute[symlink-openstudio-directories]", :immediately

    action :nothing
  end

  execute "install-openstudio-deps" do
    command "apt-get -yf install"
    action :nothing
  end
  
  execute "symlink-openstudio-directories" do
    command "cd /usr/local/lib/ruby/site_ruby/2.0.0/ && ln -sf x86_64-linux lib"
    action :nothing
  end
else
  Chef::Log.warn("Installing from a #{node['platform_family']} installer is not yet not supported by this cookbook")
end


# If working with RHEL/CENTOS then you need to install specific versions of boost and perhaps
# other dependencies; however these dependencies are not available by packages and need to be compiled.


