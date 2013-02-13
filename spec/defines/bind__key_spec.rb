require 'spec_helper'
require 'Bind'

describe 'bind::key' do
  context 'default' do
    name = 'default'
    let(:title) { 'default' }
    let(:params) {
      {
        :algorithm => 'potato',
        :secret => 'sauce'
      }
    }

    it {
      should contain_file("#{Bind::NCL_FFD}/03_named.conf.local_key_fragment_#{name}").with({
        'ensure' => 'file',
      })
    }
  end
end
