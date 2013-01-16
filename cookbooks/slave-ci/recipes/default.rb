#
# Cookbook Name:: slave-ci
# Recipe:: default
#
# Copyright 2013, National Theatre
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/hosts" do
    source "hosts"
    owner  "root"
    group  "root"
    mode   "0644"
end

case node['platform_family']
when "ubuntu"
  vhost_path = '/etc/apache2/sites-available/vhost'
when "centos"
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
when "amazon"
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
end

cookbook_file vhost_path do
    source "vhost.conf"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :restart, resources(:service => "apache2")
end