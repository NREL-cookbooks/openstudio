#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: ruby
#
# Installs OpenStudio's Required ruby dependency


include_recipe "ruby_build"
include_recipe "rbenv::system"

rbenv_ruby "2.0.0-p451" do
  environment({
                  'RUBY_CONFIGURE_OPTS' => '--enable-shared', # needs to be set for openstudio linking
                  'CONFIGURE_OPTS' => '--disable-install-doc'
              })
end

rbenv_global "2.0.0-p451"

rbenv_gem "bundler" do
  rbenv_version "2.0.0-p451"
end


