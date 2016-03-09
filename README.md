Chef-Guard
==========
The Chef-Guard cookbook installs and configures Chef-Guard into your environment

Attributes
----------
Please check http://xanzy.io/projects/chef-guard for all needed details

Usage
-----
This cookbook uses [Chef-Vault](https://github.com/chef/chef-vault) to store the .pem file content, bookshelf key, and bookshelf secret. The pem file is the private key of the Chef user that Chef-Guard uses to interact with the Chef server and Supermarket. Bookshelf is an internal component of your Chef installation and is used to store uploaded cookbook files.

Please see the following examples for creating the vault items:

```
knife vault create chef-guard chef.pem -M client -S "name:some-node-search" -A your-chef-username --file chef.pem
```

The bookshelf keys are created by Chef during install time and are saved in either /etc/chef-server/chef-server-secrets.json (for Open Source Chef) or /etc/opscode/private-chef-secrets.json (for Enterpise Chef and Chef 12) and look something like this in those files:

```
 "bookshelf": {
    "access_key_id": "xxxxxx",
    "secret_access_key": "yyyyyy"
 }
```

So just get the keys from one of those files and create the vault like this to get yourself going:

```
knife vault create chef-guard chef.bookshelf -M client -S "name:some-node-search" -A your-chef-username '{"key":"xxxxxx","secret":"yyyyyy"}'
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
