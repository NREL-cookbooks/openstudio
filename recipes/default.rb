#
# Cookbook Name:: openstudio
# Recipe:: default
#
# Copyright 2013, Alliance for Sustainable Energy

if platform_family?('debian')
  include_recipe 'apt'
elsif platform_family?('rhel')
  include_recipe 'yum'
  include_recipe 'yum-epel'
end

include_recipe 'openstudio::ruby' unless node[:openstudio][:skip_ruby_install]

# override version of energyplus based on the openstudio version
if Chef::VersionConstraint.new('>= 1.5.4').include?(node[:openstudio][:version])
  node.default[:energyplus][:version] = '820009'
  node.default[:energyplus][:long_version] = '8.2.0'
  node.default[:energyplus][:git_tag] = 'v8.2.0-Update-1.2'
  node.default[:energyplus][:sha] = '8397c2e30b'
elsif Chef::VersionConstraint.new('>= 1.3.2').include?(node[:openstudio][:version])
  node.default[:energyplus][:version] = '810009'
  node.default[:energyplus][:long_version] = '8.1.0'
else
  node.default[:energyplus][:version] = '800009'
  node.default[:energyplus][:long_version] = '8.0.0'
end

include_recipe 'energyplus'
include_recipe "openstudio::install_#{node[:openstudio][:install_method]}"

template '/etc/profile.d/openstudio.sh' do
  source 'openstudio.sh.erb'
  mode 00644

  only_if { node[:openstudio][:add_library_to_path] }
end
