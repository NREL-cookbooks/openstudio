#
# Author:: Nicholas Long (<nicholas.long@.nrel.gov>)
# Cookbook Name:: openstudio
# Recipe:: ruby
#
# Installs OpenStudio's Required ruby dependency

include_recipe "rbenv"
include_recipe "rbenv::ruby_build"

# Set env variables as they are needed for openstudio linking to ruby
ENV['RUBY_CONFIGURE_OPTS'] = '--enable-shared'
ENV['CONFIGURE_OPTS'] = '--disable-install-doc'

rbenv_ruby node[:openstudio][:ruby][:version] do
  global true
end

%w(bundler ruby-prof).each do |g|
  rbenv_gem g do
    ruby_version node[:openstudio][:ruby][:version]
  end
end

