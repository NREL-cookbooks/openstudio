#
# Cookbook Name:: openstudio
# Recipe:: default
#
# Copyright 2013, NREL

# If working with RHEL/CENTOS then you need to install specific versions of boost and perhaps
# other dependencies; however these dependencies are not available by packages and need to be compiled.

if platform_family?("rhel")
  #download and build boost
  remote_file "#{Chef::Config[:file_cache_path]}/boost_1_46_1.tar.gz" do
    source "http://sourceforge.net/projects/boost/files/boost/1.46.1/boost_1_46_1.tar.gz"
    mode 00755
    checksum "68f555b7f1bcaa8e1e3b5464fcefdd9464b421546b80e2bbb8a843687ef84002"
  end

  bash "install_boost_1.46.1 -- this may take some time" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    tar -xzf boost_1_46_1.tar.gz
    rm boost_1_46_1.tar.gz
    cd boost_1_46_1
    ./bootstrap.sh
    ./bjam
    ./bjam install
    cd ..

    EOH

    #rm -rf boost_1_46_1
    not_if { ::File.exists?("/usr/local/lib/libboost-filesystem.so.1.46.1") }
  end
end


# Install OpenStudio

if platform_family?("debian")
  # handle the differing platforms
  remote_file "#{Chef::Config[:file_cache_path]}/OpenStudio-#{node[:openstudio][:version]}-Linux.deb" do
    source "http://developer.nrel.gov/downloads/buildings/OpenStudio-#{node[:openstudio][:version]}-Linux.deb"
    mode 00755
    #checksum "89c6874574d84f5e636a1b2a6690737ca48ed383090646f97890b9eadd0944fa"
  end

  # right now just use the version the is in the directory
  bash "install_openstudio" do
    #install the non x86 version
    cwd Chef::Config[:file_cache_path]

    code <<-EOH
      dpkg -i OpenStudio-#{node[:openstudio][:version]}-Linux.deb
      apt-get -f install -y
      #install known dependencies
      apt-get install libgl1-mesa-glx -y

      echo "mapping x86_64 bit to lib name to allow for openstudio to load correctly"
      cd /usr/local/lib/site_ruby/1.8/
      mv x86_64-linux lib
    EOH

    not_if { ::File.exists?("/usr/local/lib/site_ruby/1.8/openstudio.rb") }
  end



elsif platform_family?("rhel")
  # handle the differing platforms
  remote_file "#{Chef::Config[:file_cache_path]}/OpenStudio-#{node[:openstudio][:version]}-Linux.sh" do
    source "http://developer.nrel.gov/downloads/buildings/OpenStudio-#{node[:openstudio][:version]}-Linux.sh"
    mode 00755
    checksum node[:openstudio][:checksum]
  end

  # only works for 64 bit machines right now because it has to move lib directories:  x86_64-linux
  bash "install_openstudio" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      chmod +x OpenStudio-#{node[:openstudio][:version]}-Linux.sh
      ./OpenStudio-#{node[:openstudio][:version]}-Linux.sh --skip-license --include-subdir
      mv OpenStudio-#{node[:openstudio][:version]}-Linux/usr/local /opt/OpenStudio-#{node[:openstudio][:version]}-Linux/
      rm -rf OpenStudio-#{node[:openstudio][:version]}-Linux

      echo "mapping x86_64 bit to lib name to allow for openstudio to load correctly"
      cd /opt/OpenStudio-#{node[:openstudio][:version]}-Linux/lib/site_ruby/1.8/
      mv x86_64-linux lib
    EOH

    #mv /opt/OpenStudio-#{node[:openstudio][:version]}-Linux/
    #rsync -a --delete-delay apache-solr-#{version}/dist/ #{node[:solr][:dist_dir]}
    #rsync -a --delete-delay apache-solr-#{version}/contrib/ #{node[:solr][:contrib_dir]}

    not_if { ::File.exists?("/opt/OpenStudio-#{node[:openstudio][:version]}-Linux/lib/site_ruby/1.8/openstudio.rb") }
  end

  template "/etc/profile.d/openstudio.sh" do
    source "openstudio.sh.erb"
    mode 00644
  end


end
