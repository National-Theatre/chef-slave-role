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
when "rhel", "fedora", "centos"
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
  package 'java-1.7.0-openjdk' do
    action :install
  end
when "amazon"
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
else
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
end

include_recipe "slave-ci::install_vhosts"

#include_recipe "slave-ci::selenium"

package 'ant' do
  action :install
end
#
# Install nodeJS for zombieJS
#
bash "install_zombie" do
  code "mkdir -p /usr/local/src"
end
case node['platform_family']
when "ubuntu"
  include_recipe "nodejs::install_from_package"
when "rhel", "fedora", "centos", "amazon"
  include_recipe "nodejs::install_from_binary"
else
  include_recipe "nodejs"
end

bash "install_zombie" do
  code "npm install zombie --global"
end

bash "install_qunit" do
  code "npm install qunit --global"
end
