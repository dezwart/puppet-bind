require 'spec_helper'
require 'Bind'

describe 'bind::masters' do
  context 'default' do
    name = 'default'
    let(:title) { 'default' }
    let(:params) {
      {
        :addresses => [ '127.0.0.1']
      }
    }

    it {
      should contain_file("#{Bind::NCL_FFD}/02_named.conf.local_masters_fragment_#{name}").with({
        'ensure' => 'file',
      })
    }
  end
end
