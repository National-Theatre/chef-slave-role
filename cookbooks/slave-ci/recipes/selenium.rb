#
# Cookbook Name:: slave-ci
# Recipe:: selenium
#
# Install Firefox and selenium
# Install Chrome for non amazon installs
#
# Copyright 2013, National Theatre
#
# All rights reserved - Do Not Redistribute
#
if node['platform'] != 'amazon'
  unless FileTest.exists?("/usr/bin/google-chrome")
    case node['platform_family']
    when "rhel", "fedora", "centos"
      include_recipe "yum::default"
      yum_repository "chrome" do
	description "google-chrome - 64-bit"
	key "google-chrome-stable"
	url "http://dl.google.com/linux/chrome/rpm/stable/x86_64"
	gpgkey "https://dl-ssl.google.com/linux/linux_signing_key.pub"
	action :create
      end
      package 'google-chrome-stable' do
	action :install
      end
    when "debian"
      bash "chrome_key" do
	code "(cd /tmp; wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb)"
      end
      bash "chrome_install" do
	code "(cd /tmp; dpkg -i ./google-chrome*.deb)"
      end
      bash "chrome_tidy" do
	code "(cd /tmp; rm ./google-chrome*.deb)"
      end
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
  package 'firefox' do
    action :install
  end
else
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