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

# First get the needed bookshelf key and secret from a Chef-Vault
bookshelf = ChefVault::Item.load(node['chef-guard']['vault'], node['chef-guard']['vault_item'])
# Then set the s3 attributes to the correct values...
node.default['chef-guard']['config']['chef']['bookshelfkey']    = bookshelf['key']
node.default['chef-guard']['config']['chef']['bookshelfsecret'] = bookshelf['secret']

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

# Set init style for supported platforms
case node['platform_family']
when 'rhel'
  # CentOS/RHEL 7 and up
  if node['platform_version'].to_i >= 7
    INIT_SYSTEM = 'systemd'
  # CentOS/RHEL 6 (not supporting 5)
  else
    INIT_SYSTEM = 'upstart'
  end
when 'debian'
  # For ubuntu 14.10 and below
  if node['platform'] == 'ubuntu' && node['platform_version'].to_i <= 14.10
    INIT_SYSTEM = 'upstart'
  # For all other ubuntu/debian versions (ubuntu 14.10 and up, debian 8 and up)
  else
    INIT_SYSTEM = 'systemd'
  end
end

# Create init scripts
case INIT_SYSTEM
when 'upstart'
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
when 'systemd'
  template '/etc/systemd/system/chef-guard.service' do
    source 'chef-guard.service.erb'
    notifies :run, 'execute[systemctl-daemon-reload]'
    notifies :restart, 'service[chef-guard]'
  end
end

# Create chef-guard configuration file
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

unless node['chef-guard']['config']['supermarket'].nil?
  supermarketpem = ChefVault::Item.load(node['chef-guard']['vault'], File.basename(node['chef-guard']['config']['chef']['key']))
  file node['chef-guard']['config']['supermarket']['key'] do
    content supermarketpem['file-content']
    backup false
  end
end

template "#{node['chef-guard']['install_dir']}/cg_foodcritic_tests.rb" do
  source 'cg_foodcritic_tests.rb.erb'
  backup false
  variables(
    :recipe_file => (__FILE__).to_s.split("cookbooks/")[1],
    :template_file => source.to_s,
    :matches => node['chef-guard']['foodcritic']['matches']
  )
end

# Service start/stop procedure
case INIT_SYSTEM
when 'upstart'
  service 'chef-guard' do
    provider Chef::Provider::Service::Upstart
    supports :restart => true, :reload => true, :status => true
    action :start
    only_if { File.exists?("#{node['chef-guard']['install_dir']}/chef-guard") }
  end
when 'systemd'
  execute 'systemctl-daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end
  service 'chef-guard' do
    action [:enable, :start]
  end
end
