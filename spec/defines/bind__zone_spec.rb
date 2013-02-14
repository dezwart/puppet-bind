require 'spec_helper'
require 'Bind'

describe 'bind::zone' do
  let(:params) {
    {
      :mname => 'localhost',
      :rname => 'admin',
      :serial => 1,
      :refresh => 86400,
      :failed_refresh_retry => 3600,
      :expire => 86400,
      :minimum => 3600,
      :ttl => 86400,
      :records => [ '' ],
      :mode => 'master',
      :masters => [ '' ],
      :allow_update => false,
      :forwarders => [ '' ],
      :replace => true
    }
  }

  context 'default' do
    name = 'default'
    let(:title) { name }

    it {
      should contain_file("#{Bind::NCL_FFD}/01_named.conf.local_zone_fragment_#{name}").with({
        'ensure' => 'file',
      })

      should contain_file("#{Bind::ZONE_DIR}/db.#{name}").with({
        'ensure' => 'file',
        'replace' => 'true',
      })
    }
  end

  context 'not_master' do
    name = 'not_master'
    let(:title) { name }
    let(:params) {
      {
        :mode => 'slave'
      }
    }

    it {
      should_not contain_file("#{Bind::ZONE_DIR}/db.#{name}")
    }
  end

  context 'replace' do
    name = 'replace'
    let(:title) { name }
    let(:params) {
      {
        :replace => 'false'
      }
    }

    it {
      should contain_file("#{Bind::ZONE_DIR}/db.#{name}").with({
        'ensure' => 'file',
        'replace' => 'false',
      })
    }
  end
end
