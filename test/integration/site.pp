# This manifest is the entry point for `rake test:integration`.
# Use it to set up integration tests for this Puppet module.

# Update Debian package index before doing anything else
class apt_get_update {
  exec { '/usr/bin/apt-get -y update': }
}
stage { 'pre': before => Stage['main'] }
class { 'apt_get_update': stage => 'pre' }

# Test the module
include skeleton
