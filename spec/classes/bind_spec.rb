require 'spec_helper'
require 'Bind'

describe 'bind' do
  context 'default' do
    it {
      should contain_package(Bind::PACKAGE)
    }

    it {
      should contain_service(Bind::SERVICE)
    }

    it {
      should contain_file(Bind::CONF_DIR).with({
        'ensure' => 'directory',
      })

      should contain_file(Bind::ZONE_DIR).with({
        'ensure' => 'directory',
      })
    }

    it {
      should contain_file(Bind::NCO).with({
        'ensure' => 'file',
      })
    }

    it {
      should contain_file(Bind::NCL).with({
        'ensure' => 'file',
      })

      should contain_file(Bind::NCL_FFD).with({
        'ensure' => 'directory',
      })

      should contain_file(Bind::NCL_PREAMBLE).with({
        'ensure' => 'file',
      })

      should contain_exec(Bind::NCL_FILE_ASSEMBLE)
    }
  end
end
