name             'chef-guard'
maintainer       'Sander van Harmelen'
maintainer_email 'sander@xanzy.io'
license          'Apache 2.0'
description      'Installs/Configures Chef-Guard'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.2'

%w(redhat centos ubuntu).each do |os|
  supports os
end
