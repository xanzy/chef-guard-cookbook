Chef-Guard
==========
The Chef-Guard cookbook installs and configures Chef-Guard into your environment

Attributes
----------
Please check http://xanzy.io/projects/chef-guard for all needed details

Usage
-----
This cookbook uses [Chef-Vault](https://github.com/Nordstrom/chef-vault) to store (among some other things, see the NOTE below) the .pem file content. Please see the following example for creating the vault items:
`knife vault create chef-guard chef.pem -M client -S "name:some-node-search" -A your-chef-username --file chef.pem`

Note:
-----
Some addional info about the chef.s3 Chef-Vault (the name is configurable by the way), this vault does **NOT** have to contain any actual S3 keys (unless you configured your Chef backend to use real S3 storage), but it needs to contain the keys that are used by Chef to talk to the bookshelf. The bookshelf is an internal component of your Chef installation and is used to store uploaded cookbook files. The keys are created by Chef during install time and are saved in either /etc/chef-server/chef-server-secrets.json (for Open Source Chef) or /etc/opscode/private-chef-secrets.json (for Enterpise Chef) and look something like this in those files:

```
 "bookshelf": {
    "access_key_id": "xxxxxx",
    "secret_access_key": "xxxxxx"
 }
```

So just get the keys from one of those files and create the vault like this to get yourself going:

```
knife vault create passwords chef.s3 -M client -S "name:some-node-search" -A your-chef-username '{"key":"xxxxxx","secret":"xxxxxx"}'
```

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
