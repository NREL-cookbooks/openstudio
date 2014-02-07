#
# Cookbook Name:: openstudio
# Recipe:: default
#
# Copyright 2013, Alliance for Sustainable Energy

include_recipe "energyplus"
include_recipe "openstudio::install_#{node[:openstudio][:install_method]}"

if node[:openstudio][:add_library_to_path]
  template "/etc/profile.d/openstudio.sh" do
    source "openstudio.sh.erb"
    mode 00644
  end
end
