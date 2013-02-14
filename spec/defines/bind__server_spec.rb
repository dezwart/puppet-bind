require 'spec_helper'
require 'Bind'

describe 'bind::server' do
  context 'default' do
    name = 'default'
    let(:title) { 'default' }
    let(:params) {
      {
        :key => [ 'schmoo' ]
      }
    }

    it {
      should contain_file("#{Bind::NCL_FFD}/04_named.conf.local_servers_fragment_#{name}").with({
        'ensure' => 'file',
      })
    }
  end
end
