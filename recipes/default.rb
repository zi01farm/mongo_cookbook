#
# Cookbook:: mongo_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
apt_update "update" do
  action :update
end

apt_repository 'mongodb-org' do
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key 'D68FA50FEA312927'
  uri 'https://repo.mongodb.org/apt/ubuntu'
  distribution "xenial/mongodb-org/3.2"
  components ['multiverse']
end

package "mongodb-org" do
  action :upgrade
end

service "mongod" do
  supports status: true, restart: true, reload: true
  action [:enable,:start]
end

file "/etc/mongod.conf" do
  action :delete
end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables(port: node['mongo']['port'],
            ip_addresses: node['mongo']['ip_address'])
  notifies :restart, 'service[mongod]'
end

file "/lib/systemd/system/mongod.service" do
  action :delete
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  notifies :restart, 'service[mongod]'
end
