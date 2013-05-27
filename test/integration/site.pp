# This manifest is the entry point for `rake test:integration`.
# Use it to set up integration tests for this Puppet module.

# Test the module
sshuserconfig { 'vagrant' : }
sshuserconfig::remotehost { 'someidentifier' :
  unix_user           => 'vagrant',
  remote_hostname     => 'github.com',
  remote_username     => 'git',
  private_key_content => "some privkey content\n",
  public_key_content  => "some pubkey content\n"
}

sshuserconfig::remotehost { 'someidentifier2' :
  unix_user           => 'vagrant',
  remote_hostname     => 'github.com',
  remote_username     => 'git',
  private_key_content => "some privkey content2\n",
  public_key_content  => "some pubkey content2\n"
}
