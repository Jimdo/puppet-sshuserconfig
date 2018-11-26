require 'spec_helper'

describe 'sshuserconfig::remotehost' do
  some_unix_user = 'unixuser'

  some_host = 'github.com'
  some_other_host = 'some.other.remotehost.tld'

  default_port = '22'
  some_git_remote_user = 'git'

  some_hostalias = "github_com_somerepo"
  some_other_hostalias = "github_com_someotherrepo"

  some_private_key_content = 'some private content'
  some_other_private_key_content = 'some other private content'

  some_public_key_content = 'some public content'
  some_other_public_key_content = 'some other public content'

  ssh_config_dir_prefix = "/home/#{some_unix_user}/.ssh"

  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat'
  } }

  let (:title) { some_hostalias }
  let (:params) {
    {
      :unix_user           => some_unix_user,
      :remote_hostname     => some_host,
      :remote_username     => some_git_remote_user,
      :private_key_content => some_private_key_content,
      :public_key_content  => some_public_key_content
    }
  }

  it 'should only use the given IdentityFile' do
    should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{some_hostalias}")\
      .with_content(%r{^\s+IdentitiesOnly\s+yes$})
  end

  it 'should have a configurable port' do
    params[:remote_port] = 2022
    should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{some_hostalias}")\
      .with_content(%r{^\s+Port\s+2022$})
  end

  context 'with special ssh configured ssh directory' do

    let(:ssh_config_dir_prefix) { "/some/special/path/.ssh" }

    it 'should accept a special homedir' do
      params[:ssh_config_dir] = ssh_config_dir_prefix
      ssh_config_file = "#{ssh_config_dir_prefix}/config"
      should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{some_hostalias}")\
        .with_target(ssh_config_file)
    end
  end

  context 'with connect timeout set' do
    it 'should have ssh connection timeout set to 10 seconds' do
      params[:connect_timeout] = 10
      should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{some_hostalias}")\
        .with_content(%r{^\s+ConnectTimeout\s+10$}u)
    end
  end

  (1..2).each do |count|

    context "with #{count} defined sshuserconfig directives for the same unix user" do

      let(:ssh_config_file) {"#{ssh_config_dir_prefix}/config" }

      it 'should initialize concat for a given unix user' do
        ssh_config_dir_prefix = "/home/#{some_unix_user}/.ssh"
        ssh_config_file = "#{ssh_config_dir_prefix}/config"

        should contain_concat(ssh_config_file) \
          .with({
            :owner => some_unix_user,
          })
      end

      test_matrix = [
        {
          :remote_host         => some_host,
          :unix_user           => some_unix_user,
          :host_alias          => some_hostalias,
          :private_key_content => some_private_key_content,
          :public_key_content  => some_public_key_content,
        }
      ]

      if count == 2 then
        test_matrix << {
          :remote_host         => some_other_host,
          :unix_user           => some_unix_user,
          :host_alias          => some_other_hostalias,
          :private_key_content => some_other_private_key_content,
          :public_key_content  => some_other_public_key_content,
        }

        let (:pre_condition) {
<<-EOF
sshuserconfig::remotehost { #{some_other_hostalias} :
  unix_user           => '#{some_unix_user}',
  remote_hostname     => 'some.other.remotehost.tld',
  remote_username     => '#{some_git_remote_user}',
  private_key_content => '#{some_other_private_key_content}',
  public_key_content  => '#{some_other_public_key_content}',
}
EOF
        }
      end

      test_matrix.each_with_index do |test_data, i|

        synthesized_privkey_path = "#{ssh_config_dir_prefix}/id_rsa_#{test_data[:host_alias]}"
        synthesized_pubkey_path = "#{ssh_config_dir_prefix}/id_rsa_#{test_data[:host_alias]}.pub"

        context "with remote host set to #{test_data[:remote_host]} for the defined remote host no #{i+1}" do

          it 'should create a host config for a given unix user => hostalias/host/user/port/privkey/pubkey/' do
            should contain_concat__fragment("ssh_userconfig_#{test_data[:unix_user]}_#{test_data[:host_alias]}")\
              .with_content(%r{Host\s+#{test_data[:host_alias]}
\s+HostName\s+#{test_data[:remote_host]}
\s+IdentitiesOnly\s+yes
\s+IdentityFile\s+#{synthesized_privkey_path}
\s+Port\s+#{default_port}
\s+PubkeyAuthentication\s+yes
\s+User\s+#{some_git_remote_user}
}u)\
              .with_target(ssh_config_file)
          end

          it 'should create the pubkey/privkey files for a given unix user => hostalias/host/user/port/privkey/pubkey key' do
            should contain_file("privateKey_#{test_data[:host_alias]}") \
                .with ({
                        :ensure  => 'present',
                        :content => test_data[:private_key_content],
                        :path    => synthesized_privkey_path,
                        :owner   => test_data[:unix_user],
                        :group   => test_data[:unix_user],
                        :mode    => '0600',
                })

            should contain_file("publicKey_#{test_data[:host_alias]}") \
                .with ({
                        :ensure  => 'present',
                        :content => test_data[:public_key_content],
                        :path    => synthesized_pubkey_path,
                        :owner   => test_data[:unix_user],
                        :group   => test_data[:unix_user],
                        :mode    => '0600',
                })
          end
        end
      end
    end
  end
end
