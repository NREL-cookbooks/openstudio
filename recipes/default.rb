#
# Cookbook Name:: openstudio
# Recipe:: default
#
# Copyright 2013, NREL



# handle the differing platforms
remote_file "#{Chef::Config[:file_cache_path]}/OpenStudio-#{node[:openstudio][:version]}-Linux.sh" do
  source "http://zerodev-128488.nrel.gov/openstudio/OpenStudio-#{node[:openstudio][:version]}-Linux.sh"
  mode 00755
  checksum node[:openstudio][:checksum]
end


# only works for 64 bit machines right now because it has to move lib directories:  x86_64-linux
bash "install_openstudio" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    chmod +x OpenStudio-#{node[:openstudio][:version]}-Linux.sh
    OpenStudio-#{node[:openstudio][:version]}-Linux.sh --skip-license --include-subdir
    mv OpenStudio-#{node[:openstudio][:version]}-Linux/usr/local /opt/OpenStudio-#{node[:openstudio][:version]}-Linux/

  EOH

  #mv /opt/OpenStudio-#{node[:openstudio][:version]}-Linux/
  #rsync -a --delete-delay apache-solr-#{version}/dist/ #{node[:solr][:dist_dir]}
  #rsync -a --delete-delay apache-solr-#{version}/contrib/ #{node[:solr][:contrib_dir]}

  not_if { ::Dir.exists?("/opt/OpenStudio-#{node[:openstudio][:version]}-Linux/") }
end

template "/etc/profile.d/openstudio.sh" do
  source "openstudio.sh.erb"
  mode 00644
end

#bash "install_profile" do
#  cwd "/etc/profile.d"
  #export OPENSTUDIO_ROOT=/opt/OpenStudio-0.9.3.10197-Linux/
  #export PATH=$OPENSTUDIO_ROOT/bin:$PATH
#end