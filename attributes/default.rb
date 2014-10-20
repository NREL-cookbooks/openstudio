default[:openstudio][:install_method] = "installer"
if platform_family?('rhel')
  # force source installation on rhel since no package is provided (with ruby 2.0 support)
  default[:openstudio][:install_method] = "source"
end

# add openstudio ruby library to the path
default[:openstudio][:add_library_to_path] = true

# set the version that is going to be in
#   This should be the version that is in the CMakeFile that you are buildingstalled or built
default[:openstudio][:version] = "1.3.2"

# default versions
default[:openstudio][:installer][:origin] = 'developer' # developer or url
default[:openstudio][:installer][:version_revision] = "386caf0e00"
default[:openstudio][:installer][:platform] = "Linux-Ruby2.0"
default[:openstudio][:installer][:download_url] = "http://developer.nrel.gov/downloads/buildings/openstudio/builds"

# example from pulling from any url
#default[:openstudio][:installer][:origin] = 'url'
#default[:openstudio][:installer][:version_revision] = "6fca1e6df0"
#default[:openstudio][:installer][:download_url] = "https://github.com/NREL/OpenStudio/releases/download/v1.5.1-test-packaging.4"
#default[:openstudio][:installer][:download_filename] = "OpenStudio-1.5.1.6fca1e6df0-Linux.deb"

# skip ruby installation (make sure that you do this yourself if set to true)
default[:openstudio][:skip_ruby_install] = false

# for building openstudio on the node - this is a little more involved because
# CMake holds some information that is not know "easily" to the system beforehand such as the version
# In addition, you must provide the short SHA so that the package can have a unique identifier
default[:openstudio][:source][:download_version] = "v1.3.2" # make sure to prepend the v or use the branch
default[:openstudio][:source][:version_revision] = "386caf0e00" # this is tacked onto the package 1.3.2.xyz (typically a SHA)
default[:openstudio][:source][:url] = "https://codeload.github.com/NREL/OpenStudio/zip"
default[:openstudio][:source][:build_prefix] = "/mnt"
default[:openstudio][:source][:build_qt] = false
default[:openstudio][:source][:build_testing] = "OFF" # has to be a string?

# By default it will build on n - 1 cores.  Uncomment if you want to explicitly define
# default[:openstudio][:source][:cores] = 2 # uncomment

default[:openstudio][:ruby][:version] = '2.0.0-p481'

case node[:openstudio][:install_method]
  when 'installer'
    default[:openstudio][:root_path] = "/usr/local"
    if Chef::VersionConstraint.new("~> 1.5.1").include?(node[:openstudio][:version])
      default[:openstudio][:rubylib_path] = "lib/site_ruby/2.0.0"
    else
      default[:openstudio][:rubylib_path] = "lib/ruby/site_ruby/2.0.0"
    end

  when 'source'
    default[:openstudio][:root_path] = "#{node[:openstudio][:source][:build_prefix]}/openstudio-#{node[:openstudio][:version]}"
    default[:openstudio][:rubylib_path] = "OpenStudioCore-prefix/src/OpenStudioCore-build/ruby"
  else
end
