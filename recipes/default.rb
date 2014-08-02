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
  backup false
  source node['chef-guard']['url']
  checksum node ['chef-guard']['checksum']
  notifies :stop, 'service[chef-guard]', :immediately
  notifies :run, 'execute[extract_download]', :immediately
end

execute 'extract_download' do
  cwd node['chef-guard']['install_dir']
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{File.basename(node['chef-guard']['url'])}"
  action :nothing
end



service 'chef-guard' do
  start_command 'start chef-guard'
  stop_command 'stop chef-guard'
  status_command 'status chef-guard'
  reload_command 'reload chef-guard'
  restart_command 'restart chef-guard'
  status :restart => true, :reload => true, :status => true
  action :start
end