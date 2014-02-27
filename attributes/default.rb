default[:openstudio][:install_method] = "installer"
#default[:openstudio][:install_method] = "source"
default[:openstudio][:add_library_to_path] = true

# default versions
default[:openstudio][:installer][:version] = "1.2.4"
default[:openstudio][:installer][:version_revision] = "4bfc685068"
default[:openstudio][:installer][:platform] = "Linux-Ruby2.0"
default[:openstudio][:installer][:download_url] = "http://developer.nrel.gov/downloads/buildings/openstudio/builds"

# for building openstudio on the node
default[:openstudio][:source][:version] = "1.2.4"
default[:openstudio][:source][:url] = "https://github.com/NREL/OpenStudio/archive"

# by default it will build on n - 1 cores.  Uncomment if you want to explicitly define
#default[:openstudio][:source][:cores] = 2 # uncomment 

case node[:openstudio][:install_method]
	when 'installer'
		default[:openstudio][:root_path] = "/usr/local"
		default[:openstudio][:rubylib_path] = "lib/ruby/site_ruby/2.0.0"

	when 'source'
		default[:openstudio][:root_path] = "/usr/local/openstudio-#{node[:openstudio][:source][:version]}"
		default[:openstudio][:rubylib_path] = "OpenStudioCore-prefix/src/OpenStudioCore-build/ruby"
    else
end


