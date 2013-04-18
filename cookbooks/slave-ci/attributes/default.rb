#
# Cookbook Name:: slave-ci
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['slave-ci']['jenkins']['workspace'] = "/home/ec2-user/workspace" 
default['slave-ci']['jenkins']['host']      = "http://localhost"
default['slave-ci']['jenkins']['port']      = "8080"
default['slave-ci']['jenkins']['prefix']    = "" 
default['slave-ci']['jenkins']['slave_uri'] = "/jnlpJars/slave.jar"
default['slave-ci']['user']                 = "apache"
default['slave-ci']['nodename']             = "test"
default['slave-ci']['chrome_file']          = "chromedriver2_linux64_0.7.zip"
default['slave-ci']['selenium_file']        = "selenium-server-standalone-2.32.0.jar"
