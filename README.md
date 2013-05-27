SSH Userconfig Puppet Module
============================

This module configures a sane configurable ~/.ssh/config for several users.

The main goal is to have Host aliases with different ssh keypairs working
like this:

http://blog.firmhouse.com/configuring-multiple-private-ssh-deploy-keys-in-jenkins-for-github-com

If you have several private repos in github.com and you want to have a privilege seperation (no global read-only user for all repositories),
you can easily add a separate keypair per node/node role/profile like this:

XXX doc

Requirements
------------

*List supported platforms and module dependencies here*

Manifests
---------

*List and explain the contained manifests here*

Testing
-------

Everything you need to know about testing this module is explained in
`TESTING.md`.

[![Build Status](https://travis-ci.org/Jimdo/puppet-skeleton.png?branch=master)](https://travis-ci.org/Jimdo/puppet-skeleton)

License and Author
------------------

Author:: Mathias Lafeldt (<mathias.lafeldt@gmail.com>)

Copyright:: 2013, Jimdo GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
