#
# Cookbook Name:: openstudio
# Recipe:: default
#
# Copyright 2013, Alliance for Sustainable Energy

if platform_family?('debian')
	include_recipe "apt"
elsif platform_family?('rhel')
	include_recipe "yum"
	include_recipe "yum-epel"
end

include_recipe "energyplus"
include_recipe "openstudio::install_#{node[:openstudio][:install_method]}"

template "/etc/profile.d/openstudio.sh" do
  source "openstudio.sh.erb"
  mode 00644
 
  only_if { node[:openstudio][:add_library_to_path] }
end
