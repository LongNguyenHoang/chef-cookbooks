#
# Cookbook Name:: basics
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do not Redistribute
#


# Somehow the cache is not created automatically
directory Chef::Config[:file_cache_path] do
    action :create
    recursive true
end


include_recipe 'basics::hostname'
include_recipe 'basics::aliases'
include_recipe 'basics::unicode'
include_recipe 'basics::sshusers'
include_recipe 'localbackup'


case node.platform
when 'redhat', 'centos', 'amazon'
    include_recipe 'basics::redhat'
when 'ubuntu'
    include_recipe 'basics::ubuntu'
end


node.basics.packages.each do |pkg|
    package pkg do
        unless node.basics.package_mask.include?(pkg)
            action :install
        else
            action :remove
        end
    end
end

node.basics.package_mask.each do |pkg|
    package pkg do
        unless node.basics.package_unmask.include?(pkg)
            action :remove
        else
            action :install
        end
    end
end
