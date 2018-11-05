#
# Cookbook:: zabbix_server
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package %w{ mariadb-server httpd } do
  action :install
end

remote_file '/tmp/zabbix-release-4.0-1.el7.noarch.rpm' do
  source 'https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm'
  action :create
  mode "0755"
  not_if "rpm -qa | grep -qx 'zabbix'"
end

package 'zabbix-release-4.0-1.el7.noarch.rpm' do
  source '/tmp/zabbix-release-4.0-1.el7.noarch.rpm'
  action :install
end

package %w{ zabbix-server-mysql zabbix-web-mysql zabbix-agent } do
  action :install
end

service 'mariadb' do
  action [ :enable, :start ]
end

service 'httpd' do
  action [ :enable, :start ]
  subscribes :restart, 'file[/etc/httpd/conf.d/zabbix.conf]', :immediately
end

service 'zabbix-server' do
  action [ :enable, :start ]
  subscribes :restart, 'file[/etc/zabbix/zabbix_server.conf]', :immediately
end


# end of package installs


cookbook_file '/etc/httpd/conf.d/zabbix.conf' do
  source '/etc/httpd/conf.d/zabbix.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/zabbix/zabbix_server.conf' do
  source '/etc/zabbix/zabbix_server.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/zabbix_server.conf' do
  source '/etc/zabbix/zabbix_server.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'create zabbix database' do
  command 'echo "create database zabbix character set utf8 collate utf8_bin;" | mysql -u root'# \
  not_if 'echo "show databases;" | mysql -u root | grep -qx zabbix'
end

execute 'create zabbix user' do
  command `echo "grant all privileges on zabbix.* to zabbix@localhost identified by \"password\";" | mysql -u root && echo "flush privileges;" | mysql -u root`
  not_if 'echo "SELECT User FROM mysql.user;" | mysql -uroot | grep -qx zabbix'
end

execute 'create zabbix tables' do
  command 'zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix --password="password"'
  not_if 'echo "show tables;" | mysql -uzabbix -p zabbix --password=password | grep -qx users'
end
