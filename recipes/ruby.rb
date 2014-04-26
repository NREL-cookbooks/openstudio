#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: ruby
#
# Installs OpenStudio's Required ruby dependency


include_recipe "ruby_build"
include_recipe "rbenv::system"

rbenv_ruby node[:openstudio][:ruby][:version] do
  environment({
                  'RUBY_CONFIGURE_OPTS' => '--enable-shared', # needs to be set for openstudio linking
                  'CONFIGURE_OPTS' => '--disable-install-doc'
              })
end

rbenv_global node[:openstudio][:ruby][:version]

rbenv_gem "bundler" do
  rbenv_version node[:openstudio][:ruby][:version]
end


