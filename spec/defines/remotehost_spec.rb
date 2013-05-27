require 'spec_helper'

describe 'gitremote::remotehost' do
  it 'should create a host config for a given unix user => hostalias/host/user/port/privkey/pubkey/' do
    some_unix_user = 'unixuser'
    some_host = 'hostalias.com'
    some_git_remote_user = 'git'
    host_alias = "#{some_unix_user}_#{some_hostalias}"

    some_private_key_content = ''
    some_public_key_content = ''

    let (:title) { host_alias }

    should concat_stuffs("gitremote_host_#{some_unix_user}_#{some_hostalias}")\
      .with_content(%r{Host #{host_alias}
  HostName #{some_host}
  Port #{some_port}
  User #{some_git_remote_user}
  IdentityFile #{some_private_key_file_path}}u)

  end

  it 'should create the pubkey/privkey files for a given unix user => hostalias/host/user/port/privkey/pubkey key' do
    should include_file("/home/#{some_unix_user}/.ssh/id_rsa_#{some_hostalias}").with_content(some_private_key_content)
    should include_file("/home/#{some_unix_user}/.ssh/id_rsa_#{some_hostalias}.pub").with_content(some_public_key_content)
  end

  it 'should have approoiiate defaults' do
    # port and user are defaults
  end
end