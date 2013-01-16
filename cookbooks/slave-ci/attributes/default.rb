#
# Cookbook Name:: slave-ci
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['slave-ci']['jenkins']['host'] = "http://localhost"
default['slave-ci']['jenkins']['port'] = "8080"
default['slave-ci']['jenkins']['prefix'] = "" 
default['slave-ci']['jenkins']['slave_uri'] = "/jnlpJars/slave.jar"
default['slave-ci']['user'] = "apache"
