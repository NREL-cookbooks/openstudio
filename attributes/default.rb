default[:openstudio][:install_method] = "installer"
#default[:openstudio][:install_method] = "source"
default[:openstudio][:add_library_to_path] = true

# default versions
default[:openstudio][:installer][:version] = "1.2.3"
default[:openstudio][:installer][:version_revision] = "27c8fd5adf"
default[:openstudio][:installer][:platform] = "Linux-Ruby2.0"
default[:openstudio][:installer][:download_url] = "http://developer.nrel.gov/downloads/buildings/openstudio/builds"

# for building openstudio on the node
default[:openstudio][:source][:version] = "1.2.3"
default[:openstudio][:source][:version_revision] = "27c8fd5adf"
default[:openstudio][:source][:url] = "https://github.com/NREL/OpenStudio/archive"

# by default it will build on n - 1 cores.  Uncomment if you want to explicitly define
#default[:openstudio][:source][:cores] = 2 # uncomment 
