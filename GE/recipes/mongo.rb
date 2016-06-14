#
# Cookbook Name:: GE
# Recipe:: nodejs
#
# Copyright 2016, Comprinno Technologies Pvt Ltd
#
# All rights reserved - Do Not Redistribute

#Installing updates

execute 'update' do
  command 'apt-get install update'
end

execute '"Installing MongoDB"' do
command 'apt-get install -y mongodb-org=3.0.9 mongodb-org-server=3.0.9 mongodb-org-shell=3.0.9 mongodb-org-mongos=3.0.9 mongodb-org-tools=3.0.9'
end
