#
# Cookbook Name:: slave-ci
# Recipe:: mysql
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
# 
execute "mkdir_mysql" do
  command "mkdir -p /media/mysql"
  not_if { ::File.exists?("/media/mysql/mysql.lock")}
  action :run
end
mount "/media/mysql" do
  pass     0
  fstype   "tmpfs"
  device   "tmpfs"
  options  "size=750m"
  action   [:mount, :enable]
end
execute "Create_tmpfs" do
  command "touch /media/mysql/mysql.lock"
  not_if { ::File.exists?("/media/mysql/mysql.lock")}
  action :run
end

cookbook_file "/etc/init.d/init_mysql" do
    source "init_mysql"
    owner  "root"
    group  "root"
    mode   "0755"
end

include_recipe "mysql::server"
include_recipe "mysql::client"

link "/etc/rc2.d/S11init_mysql" do
  action :create
  to "/etc/init.d/init_mysql"
  not_if {File.exists?("/etc/rc2.d/S11init_mysql")}
end

link "/etc/rc3.d/S11init_mysql" do
  action :create
  to "/etc/init.d/init_mysql"
  not_if {File.exists?("/etc/rc3.d/S11init_mysql")}
end

link "/etc/rc5.d/S11init_mysql" do
  action :create
  to "/etc/init.d/init_mysql"
  not_if {File.exists?("/etc/rc5.d/S11init_mysql")}
end
