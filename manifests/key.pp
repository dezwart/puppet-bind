# Bind DNS Server - Key type
#
#    bind::key { 'TRANSFER':
#       algorithm => '',
#       secret => '',
#    }
#
define bind::key( $algorithm, $secret ) {

    file { "$bind::named_conf_local_file_fragments_directory/03_named.conf.local_key_fragment_$name":
        ensure  => file,
        owner   => root,
        group   => $bind::group,
        mode    => '0644',
        content => template('bind/named.conf.local_key_fragment.erb'),
        require => File[$bind::named_conf_local_file_fragments_directory],
        notify  => Exec[$bind::named_conf_local_file_assemble],
    }
}

