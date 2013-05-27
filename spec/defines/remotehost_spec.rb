require 'spec_helper'

describe 'ssh-userconfig::remotehost' do
  some_unix_user = 'unixuser'
  some_host = 'github.com'
  some_port = '22'
  some_git_remote_user = 'git'
  some_hostalias = "github_com_somerepo"

  some_private_key_content = ''
  some_public_key_content = ''
  synthesized_privkey_path = "/home/#{some_unix_user}/.ssh/id_rsa_#{some_hostalias}"

  let (:title) { some_hostalias }
  let (:params) {
    {
      :unixuser => some_unix_user,
      :remote_hostname => some_host,
      :remote_username => some_git_remote_user,
      :remote_port => some_port
    }
  }
  it 'should create a host config for a given unix user => hostalias/host/user/port/privkey/pubkey/' do


    should contain_concat__fragment("ssh_userconfig_#{some_unix_user}_#{some_hostalias}")\
      .with_content(%r{Host #{some_hostalias}
  HostName #{some_host}
  Port #{some_port}
  User #{some_git_remote_user}
  IdentityFile #{synthesized_privkey_path}}u)\
      .with_target("/home/#{some_unix_user}/.ssh/config")

  end

  it 'should create the pubkey/privkey files for a given unix user => hostalias/host/user/port/privkey/pubkey key' do
    should contain_file(synthesized_privkey_path).with_content(some_private_key_content)
    should contain_file("/home/#{some_unix_user}/.ssh/id_rsa_#{some_hostalias}.pub").with_content(some_public_key_content)
  end

  it 'should have approoiiate defaults' do
    # port and user are defaults
  end

  it 'should set the appropiatre rights' do
  end
end
