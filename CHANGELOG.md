Chef-Guard CHANGELOG
====================

0.3.4
-----
- Bart Groenendal - Added systemd support for CentOS / RHEL 7 and up.

0.3.3
-----
- Sander van Harmelen - Updated the version attibutes to use the latest release of Chef-Guard v0.6.1
- Miguel Ferreira - Updated the foodcritic tests for better readability

0.3.2
-----
- Sander van Harmelen - Fixed foodcritic tests

0.3.1
-----
- Miguel Ferreira - Fixed syntax error in the custom foodcritic tests

0.3.0
-----
- Sander van Harmelen - Updated the cookbook to use Chef-Guard v0.6.0 which requires some config changes
- Sander van Harmelen - Converted the custom Chef-Guard foodcritic file to a template. You can now add a custom regex to check for certain cookbook names and the embedded foodcritic tests will only run against matching cookbooks.

0.2.7
-----
- Sander Botman - Fixed the chef-guard.conf template so it includes to the 'chefclient' section

0.2.6
-----
- Sander van Harmelen - Updated the version attibutes to use the latest release of Chef-Guard v0.5.0
- Sander van Harmelen - Added a new attribute for manageing the Chef clients path (new feature of Chef-Guard)

0.1.2
-----
- Sander van Harmelen - Changed the version attibute to point to the latest release of Chef-Guard v0.3.0

0.1.1
-----
- Sander van Harmelen - Improved some parts of the cookbook and added Chef-Vault logic to manage the secure items of this cookbook

0.1.0
-----
- Sander van Harmelen - Initial release of chef-guard-cookbook
