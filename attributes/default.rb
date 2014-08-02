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


default['chef-guard']['version']     = '0.1.0'
default['chef-guard']['install_dir'] = '/opt/chef-guard'

if kernel['machine'] =~ /x86_64/
  default['chef-guard']['url']      = "http://xanzy.io/downloads/chef-guard-v#{node['chef-guard']['version']}-linux-x64.tar.gz"
  default['chef-guard']['checksum'] = 'ce9ae08d6f97877a9b3b150cd45d5caba0f9640b1e78784d04fb0bf656133501'
else
  default['chef-guard']['url']      = "http://xanzy.io/downloads/chef-guard-v#{node['chef-guard']['version']}-linux-x86.tar.gz"
  default['chef-guard']['checksum'] = '2c8d725a649ee9af3f162fbfd02a993ac47664173d9c738dcb63c696f7554a24'
end

# These options are used for the 'Default' section
default['chef-guard']['config']['default']['listen']          = '127.0.0.2'
default['chef-guard']['config']['default']['logfile']         = '/var/log/chef-guard.log'
default['chef-guard']['config']['default']['tempdir']         = '/var/tmp/chef-guard'
default['chef-guard']['config']['default']['mode']            = 'silent'
default['chef-guard']['config']['default']['maildomain']      = ''
default['chef-guard']['config']['default']['mailserver']      = ''
default['chef-guard']['config']['default']['mailport']        = '25'
default['chef-guard']['config']['default']['mailrecipient']   = ''
default['chef-guard']['config']['default']['validatechanges'] = true
default['chef-guard']['config']['default']['commitchanges']   = true
default['chef-guard']['config']['default']['mailchanges']     = true
default['chef-guard']['config']['default']['searchgithub']    = true
default['chef-guard']['config']['default']['publishcookbook'] = true
default['chef-guard']['config']['default']['blacklist']       = ''
default['chef-guard']['config']['default']['gitorganization'] = 'chef-guard'
default['chef-guard']['config']['default']['gitcookbookorg']  = ['org1', 'org2']

# These options are used for the 'Chef' section
default['chef-guard']['config']['chef']['enterprisechef'] = true
default['chef-guard']['config']['chef']['server']         = 'chef.company.com'
default['chef-guard']['config']['chef']['port']           = '443'
default['chef-guard']['config']['chef']['sslnoverify']    = false
default['chef-guard']['config']['chef']['erchefip']       = '127.0.0.1'
default['chef-guard']['config']['chef']['erchefport']     = '8000'
default['chef-guard']['config']['chef']['s3key']          = ''
default['chef-guard']['config']['chef']['s3secret']       = ''
default['chef-guard']['config']['chef']['version']        = '11.12.0'
default['chef-guard']['config']['chef']['user']           = 'chef-guard'
default['chef-guard']['config']['chef']['key']            = "#{node['chef-guard']['install_dir']}/#{node['chef-guard']['config']['chef']['user']}.pem"

# These options are used for the 'Supermarket' section
default['chef-guard']['config']['supermarket']['server']      = 'supermarket.company.com'
default['chef-guard']['config']['supermarket']['port']        = 443
default['chef-guard']['config']['supermarket']['sslnoverify'] = false
default['chef-guard']['config']['supermarket']['version']     = '11.12.0'
default['chef-guard']['config']['supermarket']['user']        = 'chef-guard'
default['chef-guard']['config']['supermarket']['key']         = "#{node['chef-guard']['install_dir']}/#{node['chef-guard']['config']['supermarket']['user']}.pem"

# These options are used for the 'BerksAPI' section
default['chef-guard']['config']['[berksapi']['serverurl'] = 'https://api.berkshelf.com'

# These options are used for the 'Tests' section
default['chef-guard']['config']['tests']['foodcritic'] = '/opt/chef/embedded/bin/foodcritic'
default['chef-guard']['config']['tests']['rubocop']    = '/opt/chef/embedded/bin/rubocop'

# These options are used for the 'Graphite' section
default['chef-guard']['config']['graphite']['server'] = ''
default['chef-guard']['config']['graphite']['port']   = 2003

# These options are used to configure the used Git organizations
#default['chef-guard']['config']['github']['org1'] = {
#  'serverurl' => '', => defaults to github.com
#  'sslnoverify' => false,
#  'token' => 'xxx'
#}
#default['chef-guard']['config']['github']['org2'] = {
#  'serverurl' => 'https://github.company.com', => url to your Github Enterprise appliance
#  'sslnoverify' => false,
#  'token' => 'xxx'
#}

# These options are used to configure the Chef organizations (only used with Enterpise Chef)
#default['chef-guard']['config']['customers']['demo1'] = {
#  'mailchanges' => false,
#  'searchgithub' => false
#}
#default['chef-guard']['config']['customers']['demo2'] = {
#  'mailrecipient' => 'demo2@company.com',
#  'gitcookbookorg' => 'demo2-org'
#}
