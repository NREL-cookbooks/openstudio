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

chef_gem 'semantic'
require 'semantic'
require 'semantic/core_ext'

include_recipe "openstudio::ruby" unless node[:openstudio][:skip_ruby_install]

# override version of energyplus based on the openstudio version
requested_version = "1.3.0".to_version
if node[:openstudio][:install_method] == "source"
  requested_version = node[:openstudio][:source][:version].gsub('v','').to_version
else
  requested_version = node[:openstudio][:installer][:version].to_version
end

if requested_version >= "1.3.2".to_version
  node.default[:energyplus][:version] = "810009"
  node.default[:energyplus][:long_version] = "8.1.0"
else
  node.default[:energyplus][:version] = "800009"
  node.default[:energyplus][:long_version] = "8.0.0"
end

include_recipe "energyplus"
include_recipe "openstudio::install_#{node[:openstudio][:install_method]}"

template "/etc/profile.d/openstudio.sh" do
  source "openstudio.sh.erb"
  mode 00644
 
  only_if { node[:openstudio][:add_library_to_path] }
end
