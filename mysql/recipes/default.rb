#
# Cookbook:: mysql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'mariadb-server' do
  action [ :enable, :start ]
end
