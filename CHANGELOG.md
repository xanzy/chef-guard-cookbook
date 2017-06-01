Chef-Guard CHANGELOG
====================

0.4.2
-----
- Fixed attributes and chef-vault for Chef 13+ compatibility

0.4.1
-----
- Updated the version attibutes to use the latest release of Chef-Guard v0.7.1.

0.4.0
-----
- Updated the version attibutes to use the latest release of Chef-Guard v0.7.0. This also required updating some config attributes to remain compatible with the latest version.

0.3.5
-----
- Updated the version attibutes to use the latest release of Chef-Guard v0.6.2

0.3.4
-----
- Added systemd support for CentOS / RHEL 7 and up.

0.3.3
-----
- Updated the version attibutes to use the latest release of Chef-Guard v0.6.1
- Updated the foodcritic tests for better readability

0.3.2
-----
- Fixed foodcritic tests

0.3.1
-----
- Fixed syntax error in the custom foodcritic tests

0.3.0
-----
- Updated the cookbook to use Chef-Guard v0.6.0 which requires some config changes
- Converted the custom Chef-Guard foodcritic file to a template. You can now add a custom regex to check for certain cookbook names and the embedded foodcritic tests will only run against matching cookbooks.

0.2.7
-----
- Fixed the chef-guard.conf template so it includes to the 'chefclient' section

0.2.6
-----
- Updated the version attibutes to use the latest release of Chef-Guard v0.5.0
- Added a new attribute for manageing the Chef clients path (new feature of Chef-Guard)

0.1.2
-----
- Changed the version attibute to point to the latest release of Chef-Guard v0.3.0

0.1.1
-----
- Improved some parts of the cookbook and added Chef-Vault logic to manage the secure items of this cookbook

0.1.0
-----
- Initial release of chef-guard-cookbook
