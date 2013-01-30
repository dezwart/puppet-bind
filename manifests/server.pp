# Bind DNS Server - Server type
#
#    bind::server { '172.22.16.21':
#       key => 'TRANSFER',
#    }
#
define bind::server( $key = undef ) {

    file { "$bind::named_conf_local_file_fragments_directory/04_named.conf.local_servers_fragment_$name":
        ensure  => file,
        owner   => root,
        group   => $bind::group,
        mode    => '0644',
        content => template('bind/named.conf.local_servers_fragment.erb'),
        require => File[$bind::named_conf_local_file_fragments_directory],
        notify  => Exec[$bind::named_conf_local_file_assemble],
    }
}

