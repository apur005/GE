#
# Cookbook Name:: GE
# Recipe:: nodejs
#
# Copyright 2016, Comprinno Technologies Pvt Ltd
#
# All rights reserved - Do Not Redistribute

#Installing updates
apt_update if node['platform_family'] == 'debian' do
  action :update
end

#Installing Nodejs latest version
apt_package 'nodejs' do
  provider                   Chef::Provider::Package::Apt
  action                     :install
end

#Installing Python latest version
apt_package 'python' do
  provider                   Chef::Provider::Package::Apt
  action                     :install
end

#Installing Pip latest version
apt_package 'python-pip' do
  provider                   Chef::Provider::Package::Apt
  action                     :install
end

#Installing virtual env
execute 'virtual env' do
command 'pip install virtualenv' 
end

#Installing npm latest version
apt_package 'npm' do
  provider                   Chef::Provider::Package::Apt
  action                     :install
end

#Installing virtual env
execute 'virtual env' do
command 'npm install forever -g' 
end

#Installing nginx latest version
apt_package 'nginx' do
  provider                   Chef::Provider::Package::Apt
  action                     :install
end


execute 'end' do
  command 'virtualenv venv'
  action :run
  environment ({'HOME' => '/home/ubuntu'})
end

#%w{golden-eye deploy data}.each do |dir|
  #directory "/home/ubuntu/#{dir}" do
    #mode '0755'
    #owner 'root'
    #group 'root'
    #action :create
    #recursive true
  #end
#end

execute 'create folder' do
command 'mkdir -p /home/ubuntu/golden-eye/deploy/data/'
end

status_file = 'home/ubuntu/golden-eye/deploy/data/pip_reqs.txt'

file pip_reqs.txt do
  owner 'root'
  group 'root'
  mode '0755'
  content 'Eve==0.6.1
fake-useragent==0.0.8
Flask-Bcrypt==0.7.1
Flask-Login==0.3.2
Flask-WTF==0.12
jmespath==0.9.0
mock==1.3.0
mongomock==3.1.1
nose==1.3.7
peewee==2.7.4
pymongo==2.9.1
python-dateutil==2.4.2
requests==2.9.1
Scrapy==1.0.4
uWSGI==2.0.12
Flask-Compress==1.3.0
'
end

execute 'create folder' do
command 'mkdir  /home/ubuntu/golden-eye/ui'
end

execute 'create folder' do
command '
cd /home/unbuntu/golden-eye/ui
npm install'
end

status_file = 'home/ubuntu/golden-eye/deploy/data/cron_jobs.txt'

file pip_reqs.txt do
  owner 'root'
  group 'root'
  mode '0755'
  content 'SHELL=/bin/bash
PATH=/home/ubuntu/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
SCRAPY_ENV=prod

# Cleanup script
00 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/archive_logs.py
00 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/remove_stats_records_older_than_week.py

# Spider Config generation
00 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/spider_configs.py
01 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/expedia_taxes_config.py

# Alerts
#00 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/send_alert_if_not_logged_in_for_days.py
00 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/send_alert_for_0_items_once_a_day.py

# Expedia Taxes Spider
02 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py ex taxes

# Main Spiders
03 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py booking
04 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py ibibo
05 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py ex
06 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py clt
07 00 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py tg

# Combine rateplans
00 */1 * * * /home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/combine_rateplans.py

'
end

execute 'cron' do
command 'crontab -u ubuntu /home/ubuntu/golden-eye/deploy/data/cron_jobs.txt'
end


