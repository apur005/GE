#
# Cookbook Name:: GE
# Recipe:: nodejs
#
# Copyright 2016, Comprinno Technologies Pvt Ltd
#
# All rights reserved - Do Not Redistribute

#Installing updates

execute 'update' do
  command 'apt-get update'
end

execute 'adding repo' do
  command 'echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list'
end

execute 'update' do
  command 'apt-get update'
end

execute '"Installing MongoDB"' do
command 'apt-get install -y mongodb-org=3.0.9 mongodb-org-server=3.0.9 mongodb-org-shell=3.0.9 mongodb-org-mongos=3.0.9 mongodb-org-tools=3.0.9'
end

service "mongod" do
  action :stop
end

service "mongod" do
  action :start
end

bash 'Setting up MongoDB' do
  user 'ubuntu'
  tmp '/tmp'
code <<-EOH
mkdir -p /home/ubuntu/golden-eye/deploy/data/db/data
cd /home/ubuntu/golden-eye/deploy/data/db/data
mongoimport --db clt --collection locations --file clt_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db tg --collection locations --file tg_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db ibibo --collection locations --file ibibo_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db booking --collection locations --file booking_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db ex --collection locations --file ex_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db common --collection unified_hotels --file common_unified_hotels.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db common --collection users --file common_users.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
mongoimport --db common --collection currencies --file common_currencies.json --drop --stopOnError --username admin --password M0ngo@1501007 --authenticationDatabase admin
EOH
end

bash 'Setting up MongoDB' do
code <<-EOH
cd /homeu/buntu/golden-eye/deploy/data/db/users
mongo admin admin.js
mongo admin reader.js
mongo common common.js
EOH
end
