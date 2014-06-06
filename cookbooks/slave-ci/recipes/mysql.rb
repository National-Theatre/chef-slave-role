#
# Cookbook Name:: slave-ci
# Recipe:: mysql
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
# 
execute "mkdir_mysql" do
  command "mkdir -p /mnt/mysql"
  not_if { ::File.exists?("/mnt/mysql/mysql.lock")}
  action :run
end
mount "/mnt/mysql" do
  pass     0
  fstype   "tmpfs"
  device   "tmpfs"
  options  "size=500m"
  action   [:mount, :enable]
end
execute "Create_tmpfs" do
  command "touch /mnt/mysql/mysql.lock"
  not_if { ::File.exists?("/mnt/mysql/mysql.lock")}
  action :run
end

include_recipe "build-essential::default"
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "mysql-chef_gem::default"

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database_user 'drupal' do
  connection mysql_connection_info
  password   'drupal'
  action     :create
end

mysql_database_user 'drupal' do
  connection    mysql_connection_info
  password      'drupal'
  database_name 'drupal\_%'
  host          'localhost'
  action        :grant
end
