#
# Cookbook Name:: slave-ci
# Recipe:: install_vhosts
#
# Copyright 2013, National Theatre
#
# All rights reserved - Do Not Redistribute
#

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

if FileTest.exists?("#{node['slave-ci']['jenkins']['workspace']}/shed")
  web_app "nt_shed" do
    server_name 'www.shed.test.local'
    server_aliases []
    docroot "#{node['slave-ci']['jenkins']['workspace']}/shed/drupal"
    allow_override "All"
  end
end

if FileTest.exists?("#{node['slave-ci']['jenkins']['workspace']}/ntfuture")
  web_app "nt_shed" do
    server_name 'www.ntfuture.test.local'
    server_aliases []
    docroot "#{node['slave-ci']['jenkins']['workspace']}/ntfuture/drupal"
    allow_override "All"
  end
end