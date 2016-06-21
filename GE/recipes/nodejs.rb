#
# Cookbook Name:: GE
# Recipe:: nodejs
#
# Copyright 2016, Comprinno Technologies Pvt Ltd
#
# All rights reserved - Do Not Redistribute

execute 'create folder' do
command 'mkdir /home/ubuntu/golden-eye/ui'
end

execute 'update' do
  command 'apt-get update'
end

#header "Setting git configurations"
execute 'git config' do
command 'git config --global color.ui auto'
end
execute 'git config' do
command 'git config --global core.editor "vim"'
end
execute 'git config' do
command 'git config --global push.default upstream'
end
execute 'git config' do
command 'git config --global merge.conflictstyle diff3'
end

#Installing Nodejs latest version
execute 'nodejs' do
  command 'apt-get install -y nodejs'
end


#Installing npm latest version
execute 'npm' do
  command 'apt-get install -y npm'
end

#Installing virtual env
execute 'virtual env' do
command 'npm install forever -g' 
end

file '/home/ubuntu/golden-eye/ui/package.json' do
  content '{
  "name": "goldeneye",
  "version": "1.0.7",
  "description": "An AxisRooms product",
  "main": "server.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "AxisRooms",
  "license": "ISC",
  "dependencies": {
    "bcrypt-nodejs": "0.0.3",
    "body-parser": "^1.14.2",
    "cron": "^1.1.0",
    "exceljs": "0.2.3",
    "express": "^4.13.4",
    "jsonwebtoken": "^5.5.4",
    "lodash": "^4.11.1",
    "moment": "^2.13.0",
    "mongoose": "^4.3.7",
    "morgan": "^1.6.1",
    "prompt": "^1.0.0",
    "request": "^2.69.0"
  }
}
'
            mode '0755'
            owner 'ubuntu'
            group 'ubuntu'
end

execute 'node dependencies' do
cwd '/home/ubuntu/golden-eye/ui'
command 'npm install'
end





