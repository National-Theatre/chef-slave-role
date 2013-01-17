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
when "amazon"
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
else
  vhost_path = '/etc/httpd/conf.d/vhost.conf'
end

cookbook_file vhost_path do
    source "vhost.conf"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :restart, resources(:service => "apache2")
end

unless FileTest.exists?("/tmp/#{node['slave-ci']['chrome_file']}")
  remote_file "chrome" do
    path "/tmp/#{node['slave-ci']['chrome_file']}"
    source "http://chromedriver.googlecode.com/files/#{node['slave-ci']['chrome_file']}"
  end
  bash "unzip-chrome" do
    code "(cd /tmp; unzip /tmp/#{node['slave-ci']['chrome_file']})"
  end
  bash "mv-chrome" do
    code "(cd /tmp; mv chromedriver /usr/bin/chromedriver)"
  end
end

package "java" do
  action :install
end

unless FileTest.exists?("/tmp/#{node['slave-ci']['selenium_file']}")
  remote_file "selenium" do
    path "/tmp/#{node['slave-ci']['selenium_file']}"
    source "http://selenium.googlecode.com/files/#{node['slave-ci']['selenium_file']}"
  end
end

template '/etc/init.d/selenium' do
  source "selenium.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  variables()
end

service "selenium" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

remote_file "slave" do
  path "/tmp/slave.jar"
  source "#{node['slave-ci']['jenkins']['host']}:#{node['slave-ci']['jenkins']['port']}/#{node['slave-ci']['jenkins']['prefix']}/#{node['slave-ci']['jenkins']['slave_uri']}"
end

template '/etc/init.d/jenkins_slave' do
  source "jenkins_slave.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  variables()
end
service "jenkins_slave" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
