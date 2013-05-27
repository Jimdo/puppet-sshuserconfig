require 'spec_helper'

describe 'ssh-userconfig' do

  some_unix_user = 'unixuser'

  ssh_config_dir_prefix = "/home/#{some_unix_user}/.ssh"
  ssh_config_file = "#{ssh_config_dir_prefix}/config"

  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat'
  } }

  let (:title) { some_unix_user }

  it 'should initialize concat for a given unix user' do
    should contain_concat(ssh_config_file) \
      .with({
        :owner => some_unix_user,
      })
end
 
  it 'should create the .ssh folder for the given unix user' do
    should contain_file(ssh_config_dir_prefix) \
      .with ({
        :ensure => 'directory',
        :owner  => some_unix_user,
        :mode   => '700'
      })
  end

end