#
# Cookbook:: centos_common
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


package %w{epel-release  vim  git  htop } do
  action [ :install ]
end


cookbook_file '/etc/cron.hourly/chef-client' do
  source 'etc/cron.hourly/chef-client'
  mode '0755'
  action :create
end
