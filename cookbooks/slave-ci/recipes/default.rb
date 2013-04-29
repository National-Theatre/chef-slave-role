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

if FileTest.exists?("#{node['slave-ci']['jenkins']['workspace']}/bpa")
  web_app "bpa" do
    server_name 'www.bpa.test.local'
    server_aliases []
    docroot "#{node['slave-ci']['jenkins']['workspace']}/bpa/drupal"
    allow_override "All"
  end
end

if FileTest.exists?("#{node['slave-ci']['jenkins']['workspace']}/website")
  web_app "nt_website" do
    server_name 'cms.nationaltheatre.test.local'
    server_aliases []
    docroot "#{node['slave-ci']['jenkins']['workspace']}/website/drupal"
    allow_override "All"
  end
end

if FileTest.exists?("#{node['slave-ci']['jenkins']['workspace']}/pp")
  web_app "nt_pp" do
    server_name 'secure.nationaltheatre.test.local'
    server_aliases []
    docroot "#{node['slave-ci']['jenkins']['workspace']}/pp/drupal/pp/web"
    allow_override "All"
  end
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
  bash "set-chrome" do
    code "chmod 755 /usr/bin/chromedriver"
  end
end

unless FileTest.exists?("/tmp/gtk-firefox.sh")
  cookbook_file "/tmp/gtk-firefox.sh" do
    source "gtk-firefox.sh"
    owner  "root"
    group  "root"
    mode   "0544"
  end
  execute "gtk-firefox.sh" do
    command "/tmp/gtk-firefox.sh"
    action :run
    user "root"
  end
  execute "clean_out_src" do
    command "rm -r /usr/local/src"
    action :run
    user "root"
  end
end

unless FileTest.exists?("/tmp/#{node['slave-ci']['selenium_file']}")
  remote_file "selenium" do
    path "/tmp/#{node['slave-ci']['selenium_file']}"
    source "http://selenium.googlecode.com/files/#{node['slave-ci']['selenium_file']}"
    mode   "0444"
  end
end

package 'xorg-x11-server-Xvfb' do
  action :install
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