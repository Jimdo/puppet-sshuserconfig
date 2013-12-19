# This manifest is the entry point for `rake test:integration`.
# Use it to set up integration tests for this Puppet module.

# Test the module
sshuserconfig::remotehost { 'someidentifier' :
  unix_user           => 'vagrant',
  remote_hostname     => 'github.com',
  remote_username     => 'git',
  private_key_content => "some privkey content\n",
  public_key_content  => "some pubkey content\n",
  ssh_config_dir      => '/tmp'
}

sshuserconfig::remotehost { 'someidentifier2' :
  unix_user           => 'vagrant',
  remote_hostname     => 'github.com',
  remote_username     => 'git',
  private_key_content => "some privkey content2\n",
  public_key_content  => "some pubkey content2\n",
  ssh_config_dir      => '/tmp',
  connect_timeout     => 10
}
