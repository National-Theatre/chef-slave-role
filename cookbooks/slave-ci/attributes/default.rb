#
# Cookbook Name:: slave-ci
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['slave-ci']['jenkins']['host']      = "http://localhost"
default['slave-ci']['jenkins']['port']      = "8080"
default['slave-ci']['jenkins']['prefix']    = "" 
default['slave-ci']['jenkins']['slave_uri'] = "/jnlpJars/slave.jar"
default['slave-ci']['user']                 = "apache"
default['slave-ci']['nodename']             = "test"
default['slave-ci']['chrome_file']          = "chromedriver_linux32_23.0.1240.0.zip"
default['slave-ci']['selenium_file']        = "selenium-server-standalone-2.28.0.jar"
