require 'spec_helper'

describe 'sshuserconfig' do

  some_unix_user = 'unixuser'

  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat'
    } }

  let (:title) { some_unix_user }

  it 'should initialize concat for a given unix user' do
    ssh_config_dir_prefix = "/home/#{some_unix_user}/.ssh"
    ssh_config_file = "#{ssh_config_dir_prefix}/config"

    should contain_concat(ssh_config_file) \
      .with({
        :owner => some_unix_user,
      })
  end

  context 'with special ssh configured ssh directory' do
    ssh_config_dir_prefix = "/some/special/path/.ssh"
    let (:params) {
      {
        :ssh_config_dir => ssh_config_dir_prefix
      }
    }

    it 'should accept a special homedir' do
      ssh_config_file = "#{ssh_config_dir_prefix}/config"
      should contain_concat(ssh_config_file)
    end
  end

end
