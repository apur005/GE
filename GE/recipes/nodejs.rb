#
# Cookbook Name:: GE
# Recipe:: nodejs
#
# Copyright 2016, Comprinno Technologies Pvt Ltd
#
# All rights reserved - Do Not Redistribute

#Installing updates
#apt_update if node['platform_family'] == 'debian' do
  #action :update
#end
execute 'update' do
  command 'apt-get install update'
end
#Installing Nodejs latest version
execute 'nodejs' do
  command 'apt-get install -y nodejs'
end
#Installing Python latest version
execute 'python' do
  command 'apt-get install -y python'
end

#Installing Pip latest version
execute 'python-pip' do
  command 'apt-get install -y python-pip'
end

#Installing virtual env
execute 'virtual env' do
command 'pip install virtualenv' 
end

#Installing npm latest version
execute 'npm' do
  command 'apt-get install -y npm
end

#Installing virtual env
execute 'virtual env' do
command 'npm install forever -g' 
end

#Installing scrapy dependencies
execute 'scrappy dependencies' do
command 'apt-get install -y build-essential libssl-dev libffi-dev python-dev libxml2-dev libxml2-dev libxslt1-dev sqlite3'
end

#Installing nginx latest version
execute 'nginx' do
  command 'apt-get install -y nginx'
end
bash 'Configuring Nginx to Proxy Requests' do
code <<-EOH
public_ip=`wget -qO- http://instance-data/latest/meta-data/public-ipv4`
cp /home/ubuntu/golden-eye/deploy/data/api/goldeneye /etc/nginx/sites-available
sed -i "s/%PUBLIC_IP%/${public_ip}/g" /etc/nginx/sites-available/goldeneye
ln -s /etc/nginx/sites-available/goldeneye /etc/nginx/sites-enabled
service nginx restart
EOH
end

execute 'env' do
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
execute 'pip-dependencies' do
  command 'pip install Eve==0.6.1 fake-useragent==0.0.8 Flask-Bcrypt==0.7.1 Flask-Login==0.3.2  Flask-WTF==0.12 jmespath==0.9.0 mock==1.3.0 mongomock==3.1.1 nose==1.3.7 peewee==2.7.4 pymongo==2.9.1 python-dateutil==2.4.2 requests==2.9.1 Scrapy==1.0.4 uWSGI==2.0.12 Flask-Compress==1.3.0
 '
end
execute 'setting up environment variables'
command 'echo -e "
#!/bin/bash

export SCRAPY_ENV=prod
export EDITOR=vim
source $HOME/venv/bin/activate

" > $HOME/.bash_aliases'
end

execute 'create folder' do
command 'mkdir -p /home/ubuntu/golden-eye/deploy/data/'
end

execute 'create folder' do
command 'mkdir  /home/ubuntu/golden-eye/ui'
end

execute 'node dependencies' do
cwd '/home/unbuntu/golden-eye/ui'
command 'npm install'
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
# Cleanup script
cron 'clean up script' do
  hour '0'
  minute '0'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/archive_logs.py'
end

cron 'clean up script' do
  hour '0'
  minute '0'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/remove_stats_records_older_than_week.py'
end

# Spider Config generation
cron 'spider config1' do
  hour '0'
  minute '0'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/spider_configs.py'
end
cron 'spider config2' do
  hour '0'
  minute '1'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/expedia_taxes_config.py'
end

# Alerts
#cron 'alerts1' do
 # hour '0'
  #minute '0'
  #day '*'
  #month '*'
  #command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/send_alert_if_not_logged_in_for_days.py'
#end
cron 'alerts2' do
  hour '0'
  minute '0'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/send_alert_for_0_items_once_a_day.py'
end

cron 'alerts2' do
  hour '0'
  minute '02'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py ex taxes'
end
# Expedia Taxes Spider
cron 'Expedia Taxes Spider' do
  hour '0'
  minute '02'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py booking'
end
# Main Spiders
cron 'Main Spider1' do
  hour '0'
  minute '03'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py booking'
end

cron 'Main Spider2' do
  hour '0'
  minute '04'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py ibibo'
end

cron 'Main Spider3' do
  hour '0'
  minute '05'
  day '*'
  month '*'
  user 'ubuntu'
  command 'home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py ex'
end

cron 'Main Spider4' do
  hour '0'
  minute '06'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py clt'
end

cron 'Main Spider5' do
  hour '0'
  minute '07'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/launch_spiders.py tg'
end


# Combine rateplans
cron 'combine rateplans' do
  hour '0-24'
  minute '00'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/combine_rateplans.py'
end



