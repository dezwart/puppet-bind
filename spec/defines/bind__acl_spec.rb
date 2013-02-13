require 'spec_helper'
require 'Bind'

describe 'bind::acl' do
  context 'default' do
    name = 'default'
    let(:title) { 'default' }
    let(:params) { { :addresses => [ '127.0.0.1' ] } }

    it {
      #should contain_file("#{Bind::NCL_FFD}/01_named.conf.local_acl_fragment_#{name}").with({

      # Rspec doesn't have the bind:: scope, so null is interpolated instead of ${bind::ncl_ffd}
      should contain_file("/01_named.conf.local_acl_fragment_#{name}").with({
        'ensure' => 'file',
      })
    }
  end
end
