module Bind
  CN = 'bind'
  PACKAGE = "#{CN}9"
  SERVICE = PACKAGE
  USER = CN
  GROUP = CN
  CONF_DIR = "/etc/#{CN}"
  ZONE_DIR = "/var/lib/#{CN}"
  NCO = "#{CONF_DIR}/named.conf.options"
  NCL = "#{CONF_DIR}/named.conf.local"
  NCL_FFD = "#{NCL}.d"
  NCL_FILE_ASSEMBLE = 'ncl_file_assemble'
  NCL_PREAMBLE = "#{NCL_FFD}/00_named.conf.local_preamble"
end
