# Bind DNS Server - Masters type
#
#    bind::masters { 'master-servers':
#       addresses => ['172.22.16.20'],
#    }
#
define bind::masters( $addresses ) {

    file { "$bind::named_conf_local_file_fragments_directory/02_named.conf.local_masters_fragment_$name":
        ensure  => file,
        owner   => root,
        group   => $bind::group,
        mode    => '0644',
        content => template('bind/named.conf.local_masters_fragment.erb'),
        require => File[$bind::named_conf_local_file_fragments_directory],
        notify  => Exec[$bind::named_conf_local_file_assemble],
    }
}

