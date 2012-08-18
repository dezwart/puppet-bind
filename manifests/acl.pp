# Bind DNS Server - Acl type
#
#    bind::acl { 'transfer-servers':
#    }
#
define bind::acl( $addresses ) {

    file { "$bind::named_conf_local_file_fragments_directory/01_named.conf.local_acl_fragment_$name":
        ensure  => file,
        owner   => root,
        group   => $bind::group,
        mode    => '0644',
        content => template('bind/named.conf.local_acl_fragment.erb'),
        require => File[$bind::named_conf_local_file_fragments_directory],
        notify  => Exec[$bind::named_conf_local_file_assemble],
    }
}

