# Bind DNS Server - Zone type
#
# == Parameters
#
# == Variables
#
# == Examples
#
#    bind::zone_file { 'foo.com':
#    }
#
define bind::zone() {

    zone_file { $name:
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
