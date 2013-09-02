require File.expand_path('../../spec_helper', __FILE__)

describe 'default node' do
  describe "key files for remote host someidentifier" do
    describe file('/tmp/id_rsa_someidentifier') do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'vagrant' }
      it { should contain 'some privkey content' }
    end

    describe file('/tmp/id_rsa_someidentifier.pub') do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'vagrant' }
      it { should contain 'some pubkey content' }
    end
  end

  describe "key files for remote host someidentifier2" do
    describe file('/tmp/id_rsa_someidentifier2') do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'vagrant' }
      it { should contain 'some privkey content2' }
    end

    describe file('/tmp/id_rsa_someidentifier2.pub') do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'vagrant' }
      it { should contain 'some pubkey content2' }
    end
  end

  describe "ssh config" do
    describe file('/tmp/config') do
      it { should be_file }
      it { should contain <<EOS
Host someidentifier
  HostName github.com
  Port 22
  User git
  IdentityFile /tmp/id_rsa_someidentifier

Host someidentifier2
  HostName github.com
  Port 22
  User git
  IdentityFile /tmp/id_rsa_someidentifier2
  ConnectTimeout 10

EOS
}
    end
  end
end
