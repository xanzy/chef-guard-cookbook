#
# Cookbook Name:: chef-guard
# Attribute:: default
#
# Copyright 2014, Sander van Harmelen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chef_gem "chef-vault"
require 'chef-vault'

# First get the needed s3 key and secret from a Chef-Vault
s3info = ChefVault::Item.load(node['chef-guard']['vault'], node['chef-guard']['s3_vault_item'])
# Then set the s3 attributes to the correct values...
node.default['chef-guard']['config']['chef']['s3key']    = s3info['key']
node.default['chef-guard']['config']['chef']['s3secret'] = s3info['secret']

# Install the gems needed for the enabled tests
node['chef-guard']['config']['tests'].each do |k,v|
  unless v.empty?
    chef_gem k
  end
end

directory node['chef-guard']['install_dir'] do
  recursive true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{File.basename(node['chef-guard']['url'])}" do
  source node['chef-guard']['url']
  backup false
  checksum node['chef-guard']['checksum']
  notifies :stop, 'service[chef-guard]', :immediately
  notifies :run, 'execute[extract_download]', :immediately
end

execute 'extract_download' do
  cwd node['chef-guard']['install_dir']
  command "tar zxof #{Chef::Config[:file_cache_path]}/#{File.basename(node['chef-guard']['url'])}"
  action :nothing
end

template '/etc/init/chef-guard.conf' do
  source 'chef-guard.upstart.erb'
  backup false
  variables(
    :recipe_file => (__FILE__).to_s.split("cookbooks/")[1],
    :template_file => source.to_s,
    :basedir => node['chef-guard']['install_dir']
  )
  notifies :restart, 'service[chef-guard]'
end

template "#{node['chef-guard']['install_dir']}/chef-guard.conf" do
  source 'chef-guard.conf.erb'
  backup false
  variables(
    :recipe_file => (__FILE__).to_s.split("cookbooks/")[1],
    :template_file => source.to_s,
    :config => node['chef-guard']['config']
  )
  notifies :reload, 'service[chef-guard]'
end

chefpem = ChefVault::Item.load(node['chef-guard']['vault'], File.basename(node['chef-guard']['config']['chef']['key']))
file node['chef-guard']['config']['chef']['key'] do
  content chefpem['file-content']
  backup false
end

supermarketpem = ChefVault::Item.load(node['chef-guard']['vault'], File.basename(node['chef-guard']['config']['chef']['key']))
file node['chef-guard']['config']['supermarket']['key'] do
  content supermarketpem['file-content']
  backup false
end

cookbook_file 'cg_foodcritic_tests.rb' do
  path "#{node['chef-guard']['install_dir']}/cg_foodcritic_tests.rb"
end

service 'chef-guard' do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :reload => true, :status => true
  action :start
  only_if { File.exists?("#{node['chef-guard']['install_dir']}/chef-guard") }
end
