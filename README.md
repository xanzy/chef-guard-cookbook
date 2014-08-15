Chef-Guard
==========
The Chef-Guard cookbook installs and configures Chef-Guard into your environment

Attributes
----------
Please check http://xanzy.io/projects/chef-guard for all needed details

Usage
-----
This cookbook uses [Chef-Vault](https://github.com/Nordstrom/chef-vault) to store the .pem file content. Please see the following example for creating the vault items:
`knife vault create chef-guard chef.pem -M client -S "name:some-node-search" -A your-chef-username --file chef.pem`

For all other needed details please check <http://xanzy.io/projects/chef-guard>

Contributing
------------
  1. Fork the repository on Github
  2. Create a named feature branch (i.e. `add-new-recipe`)
  3. Write your change
  4. Write tests for your change (if applicable)
  5. Run the tests, ensuring they all pass
  6. Submit a Pull Request

License and Authors
-------------------
Authors: Sander van Harmelen (sander@xanzy.io)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
