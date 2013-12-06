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
      :unix_user => some_unix_user,
      :remote_hostname => some_host,
      :remote_username => some_git_remote_user,
      :private_key_content => some_private_key_content,
      :public_key_content => some_public_key_content
    }
  }

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
              .with_content(%r{Host #{test_data[:host_alias]}
  HostName #{test_data[:remote_host]}
  Port #{default_port}
  User #{some_git_remote_user}
  IdentityFile #{synthesized_privkey_path}\n\n}u)\
              .with_target(ssh_config_file)
          end

          it 'should create the pubkey/privkey files for a given unix user => hostalias/host/user/port/privkey/pubkey key' do
            should contain_file(synthesized_privkey_path).with_content(test_data[:private_key_content])
            should contain_file("/home/#{some_unix_user}/.ssh/id_rsa_#{test_data[:host_alias]}.pub").with_content(test_data[:public_key_content])
          end

          it 'should set the appropriate rights for keypair' do
            {
              synthesized_privkey_path => test_data[:private_key_content],
              synthesized_pubkey_path => test_data[:public_key_content]
            }.each_pair do |path, content|
              should contain_file(path) \
                .with ({
                  :ensure   => 'present',
                  :content  => content,
                  :owner    => some_unix_user,
                  :mode     => '600'
                })
            end
          end

          # testing it with one defined remotehost is considered
          # sufficient
          if count == 1 then

            it 'should have a configurable port' do
              params[:remote_port] = 2022
              should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{test_data[:host_alias]}")\
                .with_content(%r{^\s+Port 2022$})
            end

            context 'with special ssh configured ssh directory' do

              let(:ssh_config_dir_prefix) { "/some/special/path/.ssh" }

              it 'should accept a special homedir' do
                params[:ssh_config_dir] = ssh_config_dir_prefix
                ssh_config_file = "#{ssh_config_dir_prefix}/config"
                should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{test_data[:host_alias]}")\
                  .with_target(ssh_config_file)
              end
            end

            context 'with connect timeout set' do
              it 'should have ssh connection timeout set to 10 seconds' do
                params[:connect_timeout] = 10
                should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{test_data[:host_alias]}")\
                  .with_content(%r{^  ConnectTimeout 10$\n\n}u)
              end
            end
          end

        end
      end
    end
  end
end
