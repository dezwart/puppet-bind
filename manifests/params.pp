# Bind DNS Server - Parameters
class bind::params {
  $cn = 'bind'
  $package = "${cn}9"
  $service = "${cn}9"
  $user = $cn
  $group = $cn
  $conf_dir = "/etc/${cn}"
  $zone_dir = "/var/lib/${cn}"
  $ncl = "${conf_dir}/named.conf.local"
  $ncl_ffd = "${ncl}.d"
  $ncl_file_assemble = 'ncl_file_assemble'
  $ncl_preamble = "${ncl_ffd}/00_named.conf.local_preamble"
}
