#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: install_build
#

# install some extra packages to make this work right.
case node['platform_family']
  when "debian"
    include_recipe "apt"
    
    # install some specific packages needed to build qt, boost, openstudio
    package 'libxext-dev'
    package 'libbz2-dev'
    package 'libxt-dev'
    #package 'libqtwebkit-dev' # hopefully it works without this
    #package 'xvfb' # hopefully it works without this
  when "rhel"
    include_recipe 'yum'
    include_recipe 'bzip2-devel'
end

include_recipe "ark"

if platform_family?("debian")
  # get some high level variables

  ark "openstudio" do
    url "#{node[:openstudio][:source][:url]}/v#{node[:openstudio][:source][:version]}.tar.gz"
    version node[:openstudio][:source][:version]
    prefix_root '/usr/local'
    cmake_opts ["-DCMAKE_BUILD_TYPE=Release"]
    make_opts ["-j#{node[:openstudio][:source][:cores]}"]
    action :install_with_cmake
  end

else
  Chef::Log.warn("Building on a #{node['platform_family']} system is not yet not supported by this cookbook")
  # If working with RHEL/CENTOS then you need to install specific versions of boost and perhaps
  # other dependencies; however these dependencies are not available by packages and need to be compiled.
end




