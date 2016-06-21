#
# Cookbook Name:: GE
# Recipe:: nodejs
#
# Copyright 2016, Comprinno Technologies Pvt Ltd
#
# All rights reserved - Do Not Redistribute

#Installing updates
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
execute 'create folder' do
command 'mkdir -p /home/ubuntu/golden-eye/deploy/data/'
end

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
  hour '0-23'
  minute '00'
  day '*'
  month '*'
  user 'ubuntu'
  command '/home/ubuntu/venv/bin/python /home/ubuntu/golden-eye/db/automation/combine_rateplans.py'
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
mkdir -p /home/golden-eye/deploy/data/api/goldeneye
cp /home/ubuntu/golden-eye/deploy/data/api/goldeneye /etc/nginx/sites-available
sed -i "s/%PUBLIC_IP%/${public_ip}/g" /etc/nginx/sites-available/goldeneye
ln -s /etc/nginx/sites-available/goldeneye /etc/nginx/sites-enabled
service nginx restart
EOH
end

execute 'env' do
  cwd '/home/ubuntu/'
  command 'virtualenv venv'
  
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

file '/home/ubuntu/.bash_aliases' do
  content 'export SCRAPY_ENV=prod
            export EDITOR=vim
            source $HOME/venv/bin/activate'
            mode '0755'
            owner 'ubuntu'
            group 'ubuntu'
end

execute 'node dependencies' do
cwd '/home/ubuntu/golden-eye/ui'
command 'npm install'
end

execute 'keys' do
  command 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10'
end

execute 'adding repo' do
  command 'echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list'
  end

execute 'update' do
  command 'apt-get update'
end

execute 'Installing MongoDB' do
command 'apt-get install -y mongodb-org=3.0.9 mongodb-org-server=3.0.9 mongodb-org-shell=3.0.9 mongodb-org-mongos=3.0.9 mongodb-org-tools=3.0.9'
end

service 'mongod' do
  action :restart
end

bash 'Setting up MongoDB' do
  user 'ubuntu'
  tmp '/tmp'
code <<-EOH
mkdir -p /home/ubuntu/golden-eye/deploy/data/db/data
cd /home/ubuntu/golden-eye/deploy/data/db/data
#mongoimport --db clt --collection locations --file clt_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db tg --collection locations --file tg_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db ibibo --collection locations --file ibibo_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db booking --collection locations --file booking_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db ex --collection locations --file ex_locations.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db common --collection unified_hotels --file common_unified_hotels.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db common --collection users --file common_users.json --drop --stopOnError -v --username admin --password M0ngo@1501007 --authenticationDatabase admin
#mongoimport --db common --collection currencies --file common_currencies.json --drop --stopOnError --username admin --password M0ngo@1501007 --authenticationDatabase admin
EOH
end

bash 'Setting up MongoDB' do
code <<-EOH
mkdir -p cd /home/ubuntu/golden-eye/deploy/data/db/data/users
cd /homeu/buntu/golden-eye/deploy/data/db/users
mongo admin admin.js
mongo admin reader.js
mongo common common.js
EOH
end
