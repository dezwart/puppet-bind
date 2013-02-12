require 'spec_helper'

describe 'bind' do
  cn = 'bind'
  package = "#{cn}9"
  service = package
  user = cn
  group = cn
  conf_dir = "/etc/#{cn}"
  zone_dir = "/var/lib/#{cn}"
  nco = "#{conf_dir}/named.conf.options"
  ncl = "#{conf_dir}/named.conf.local"
  ncl_ffd = "#{ncl}.d"
  ncl_file_assemble = 'ncl_file_assemble'
  ncl_preamble = "#{ncl_ffd}/00_named.conf.local_preamble"

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

    it {
      should contain_file(nco).with({
        'ensure' => 'file',
      })
    }

    it {
      should contain_file(ncl).with({
        'ensure' => 'file',
      })

      should contain_file(ncl_ffd).with({
        'ensure' => 'directory',
      })

      should contain_file(ncl_preamble).with({
        'ensure' => 'file',
      })

      should contain_exec(ncl_file_assemble)
    }
  end
end
