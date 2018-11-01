#
# Cookbook:: centos_common
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


package %w{epel-release  vim  git  htop } do
  action [ :install ]
end


