require 'spec_helper'

describe 'bind' do
  cn = 'bind'
  package = "#{cn}9"
  service = package
  user = cn
  group = cn
  conf_dir = "/etc/#{cn}"
  zone_dir = "/var/lib/#{cn}"

  context 'default' do
    it {
      should contain_package(package)
    }

    it {
      should contain_service(service)
    }

    it {
      should contain_file(conf_dir).with({
        'ensure' => 'directory',
      })

      should contain_file(zone_dir).with({
        'ensure' => 'directory',
      })
    }
  end
end
