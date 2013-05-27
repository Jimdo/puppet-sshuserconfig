require 'spec_helper'

describe 'skeleton' do
  let (:facts) {{ :operatingsystem => 'debian' }}
  let (:params) {{ :command => '/bin/false' }}

  it 'executes sample command' do
    should contain_exec('sample_command').with_command('/bin/false')
  end

  it 'does something' do
    pending 'Replace this with meaningful tests'
  end
end
