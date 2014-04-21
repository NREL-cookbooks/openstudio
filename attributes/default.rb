default[:openstudio][:install_method] = "installer"

if platform_family?('rhel')
  # force source installation on rhel since no package is provided (with ruby 2.0 support)
  default[:openstudio][:install_method] = "source"
end
default[:openstudio][:add_library_to_path] = true

# default versions
default[:openstudio][:installer][:version] = "1.3.1"
default[:openstudio][:installer][:version_revision] = "cf41a5d03b"
default[:openstudio][:installer][:platform] = "Linux-Ruby2.0"
default[:openstudio][:installer][:download_url] = "http://developer.nrel.gov/downloads/buildings/openstudio/builds"

# skip ruby installation (make sure that you do this yourself if set to true) 
default[:openstudio][:skip_ruby_install] = false

# for building openstudio on the node
default[:openstudio][:source][:version] = "v1.3.1"  # make sure to prepend the v
default[:openstudio][:source][:url] = "https://codeload.github.com/NREL/OpenStudio/zip"
default[:openstudio][:source][:build_qt] = false

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




