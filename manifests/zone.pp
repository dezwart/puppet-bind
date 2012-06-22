# Bind DNS Server - Zone type
#
# Parameter names lifted from http://tools.ietf.org/html/rfc1035
#
# == Parameters
#
# [*mname*]
#   The <domain-name> of the name server that was the original or primary source of data for this zone.
#
# [*rname*]
#   A <domain-name> which specifies the mailbox of the person responsible for this zone.
#
# [*serial*]
#   The unsigned 32 bit version number of the original copy of the zone.
#
# [*refresh*]
#   A 32 bit time interval before the zone should be refreshed.
#
# [*_retry*]
#   A 32 bit time interval that should elapse before a failed refresh should be retried. Has a '_' to avoid ERB reserved word.
#
# [*expire*]
#    A 32 bit time value that specifies the upper limit on the time interval that can elapse before the zone is no longer authoritative.
#
# [*minimum*]
#   The unsigned 32 bit minimum TTL field that should be exported with any RR from this zone.
#
# [*ttl*]
#   SOA Resource time to live.
#
# == Variables
#
# [*zone*]
#   The zone name, based off the type instance name.
#
# == Examples
#
#    bind::zone_file { 'foo.com':
#    }
#
define bind::zone($mname = $fqdn,
        $rname = 'admin',
        $serial = 1,
        $refresh = 86400,
        $_retry = 3600,
        $expire = 86400,
        $minimum = 3600,
        $ttl = 86400 ) {

    file { "$bind::conf_dir/db.$name":
        ensure  => file,
        owner   => $bind::user,
        group   => $bind::group,
        mode    => '0644',
        content => template('bind/zone_file.erb'),
        replace => false,
        require => [Package[$bind::package], File[$bind::conf_dir]],
        notify  => Service[$bind::service],
    }

    file { "$bind::named_conf_local_file_fragments_directory/01_named.conf.local_zone_fragment_$name":
        ensure  => file,
        owner   => root,
        group   => $bind::group,
        mode    => '0644',
        content => template('bind/named.conf.local_zone_fragment.erb'),
        replace => false,
        require => File[$bind::named_conf_local_file_fragments_directory],
        notify  => Exec[$bind::named_conf_local_file_assemble],
    }
}
