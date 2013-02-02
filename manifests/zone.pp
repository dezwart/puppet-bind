# Bind DNS Server - Zone type
#
# Parameter names lifted from http://tools.ietf.org/html/rfc1035
#
# == Parameters
#
# [*mname*]
#   The <domain-name> of the name server that was the original or primary
#   source of data for this zone.
#
# [*rname*]
#   A <domain-name> which specifies the mailbox of the person responsible
#   for this zone.
#
# [*serial*]
#   The unsigned 32 bit version number of the original copy of the zone.
#
# [*refresh*]
#   A 32 bit time interval before the zone should be refreshed.
#
# [*failed_refresh_retry*]
#   A 32 bit time interval that should elapse before a failed refresh should be
#   retried.
#
# [*expire*]
#  A 32 bit time value that specifies the upper limit on the time interval
#   that can elapse before the zone is no longer authoritative.
#
# [*minimum*]
#   The unsigned 32 bit minimum TTL field that should be exported with any
#   RR from this zone.
#
# [*ttl*]
#   SOA Resource time to live.
#
# [*replace*]
#   If true, the zone file will be created if non-existent, but *never ever
#   touched again*. Even if you update its definition in Puppet, *puppet will
#   refuse to touch the existing file* Only applicable of mode == master
#
# == Variables
#
# [*zone*]
#   The zone name, based off the type instance name.
#
# == Examples
#
#  bind::zone_file { 'foo.com':
#  }
#
define bind::zone($mname = $fqdn,
    $rname = 'admin',
    $serial = 1,
    $refresh = 86400,
    $failed_refresh_retry = 3600,
    $expire = 86400,
    $minimum = 3600,
    $ttl = 86400,
    $records = undef,
    $mode = 'master',
    $masters = undef,
    $allow_update = undef,
    $forwarders = undef,
    $replace = true
) {
  if $mode == 'master' {
    file { "${bind::zone_dir}/db.${name}":
      ensure  => file,
      owner   => $bind::user,
      group   => $bind::group,
      mode    => '0644',
      replace => $replace,
      content => template('bind/zone_file.erb'),
      require => [Package[$bind::package], File[$bind::zone_dir]],
      notify  => Service[$bind::service],
    }
  }

  file { "${bind::ncl_ffd}/01_named.conf.local_zone_fragment_${name}":
    ensure  => file,
    owner   => root,
    group   => $bind::group,
    mode    => '0644',
    content => template('bind/named.conf.local_zone_fragment.erb'),
    require => File[$bind::ncl_ffd],
    notify  => Exec[$bind::ncl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
