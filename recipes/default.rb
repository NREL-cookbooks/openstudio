  #
# Cookbook Name:: openstudio
# Recipe:: default
#
# Copyright 2013, NREL

# If working with RHEL/CENTOS then you need to install specific versions of boost and perhaps
# other dependencies; however these dependencies are not available by packages and need to be compiled.

if platform_family?("debian")
  filename = "OpenStudio-#{node[:openstudio][:version]}.#{node[:openstudio][:version_revision]}-#{node[:openstudio][:platform]}.deb"
  file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
  src_path = "#{node[:openstudio][:download_url]}/#{node[:openstudio][:version]}/#{filename}"
  chk_sum = node[:openstudio][:checksum]

  remote_file file_path do
    source src_path
    checksum chk_sum
    mode 00755

    already_downloaded = File.exists?(file_path) && File.size?(file_path)
    not_if { already_downloaded }
  end

  # right now just use the version the is in the directory
  bash "install_openstudio" do
    #install the non x86 version
    cwd Chef::Config[:file_cache_path]

    code <<-EOH
      dpkg -i #{filename}
      apt-get update
      apt-get -f install -y
      #install known dependencies
      apt-get install libgl1-mesa-glx -y

      echo "mapping x86_64 bit to lib name to allow for openstudio to load correctly"
      cd /usr/local/lib/ruby/site_ruby/2.0.0/
      ln -sf x86_64-linux lib
    EOH

    version_installed = false
    if File.exists?("/usr/local/lib/ruby/site_ruby/2.0.0/openstudio.rb")
      # check the version
      version = `ruby -I /usr/local/lib/ruby/site_ruby/2.0.0/ -e "require 'openstudio'" -e "puts OpenStudio::openStudioLongVersion"`.chomp
      Chef::Log.info("Current version of OpenStudio is #{version} and requesting #{node[:openstudio][:version]}.#{node[:openstudio][:version_revision]}")
      if "#{node[:openstudio][:version]}.#{node[:openstudio][:version_revision]}".include?(version)
        version_installed = true
      end
    end

    Chef::Log.info("OpenStudio version installed is set to #{version_installed}")

    not_if { version_installed }
  end

  template "/etc/profile.d/openstudio.sh" do
    source "openstudio.sh.erb"
    mode 00644
  end
end

