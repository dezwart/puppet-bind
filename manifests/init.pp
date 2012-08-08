# Bind DNS Server
#
# == Parameters
#
# [*forwarders*]
#   Specify one or more recursive forwarders as IP addresses in dotted quad
#   format.
#
# == Variables
#
# == Examples
#
#    class { 'bind':
#        forwarders => [ '10.0.0.1', '10.0.0.2' ],
#    }
#
class bind( $forwarders = undef,
            $key_name = undef,
            $key_algorithm = undef,
            $key_secret = undef,
            $transfer_servers = undef,
            $mode = 'master',
          ) {
    $package = 'bind9'
    $service = 'bind9'
    $user = 'bind'
    $group = 'bind'
    $conf_dir = '/etc/bind'

    package { $package:
        ensure  => installed,
    }

    file { $conf_dir:
        ensure  => directory,
        owner   => root,
        group   => $group,
        mode    => '2774',
        require => Package[$package],
    }
        
    file { "$conf_dir/named.conf.options":
        ensure  => file,
        owner   => root,
        group   => $group,
        mode    => '0644',
        content => template('bind/named.conf.options.erb'),
        require => [Package[$package], File[$conf_dir]],
    }

    service { $package:
        ensure      => running,
        enable      => true,
        pattern     => '/usr/sbin/named',
        restart     => '/etc/init.d/bind9 reload',
        require     => Package[$package],
        subscribe   => File['/etc/bind/named.conf.options'],
    }

    # named.conf.local file fragments pattern, purges unmanaged files
    $named_conf_local = "$conf_dir/named.conf.local"
    $named_conf_local_file_fragments_directory = "${named_conf_local}.d"

    file { $named_conf_local:
        ensure  => file,
        owner   => root,
        group   => $group,
        mode    => '0640',
        require => Package[$package],
        notify  => Service[$service],
    }

    file { $named_conf_local_file_fragments_directory:
        ensure  => directory,
        owner   => root,
        group   => $group,
        mode    => '0700',
        require => [Package[$package], File[$conf_dir]],
        recurse => true,
        purge   => true,
        notify  => Exec['named_conf_local_file_assemble'],
    }

    $named_conf_local_file_assemble = 'named_conf_local_file_assemble'
    exec { $named_conf_local_file_assemble:
        refreshonly => true,
        require     => [ File[$named_conf_local_file_fragments_directory], File[$named_conf_local] ],
        notify      => Service[$service],
        command     => "/bin/cat ${named_conf_local_file_fragments_directory}/*_named.conf.local_* > ${named_conf_local}",
    }

    $named_conf_local_preamble = "${named_conf_local_file_fragments_directory}/00_named.conf.local_preamble"

    file { $named_conf_local_preamble:
        ensure  => file,
        owner   => root,
        group   => $group,
        mode    => '0600',
        require => Package[$package],
        content => template("bind/named.conf.local_preamble.erb"),
        notify  => Exec['named_conf_local_file_assemble'],
    }

    file { "$bind::named_conf_local_file_fragments_directory/01_named.conf.local_acl_transfer_servers_fragment_$name":
        ensure => file,
        owner => root,
        group => $bind::group,
        mode => '0644',
        content => template('bind/named.conf.local_acl_transfer_servers_fragment.erb'),
        require => File[$bind::named_conf_local_file_fragments_directory],
        notify => Exec[$bind::named_conf_local_file_assemble],
    }

    if $key_name and $key_algorithm and $key_secret {
        file { "$bind::named_conf_local_file_fragments_directory/03_named.conf.local_key_fragment_$name":
            ensure => file,
            owner => root,
            group => $bind::group,
            mode => '0644',
            content => template('bind/named.conf.local_key_fragment.erb'),
            require => File[$bind::named_conf_local_file_fragments_directory],
            notify => Exec[$bind::named_conf_local_file_assemble],
        }
        if $transfer_servers {
            file { "$bind::named_conf_local_file_fragments_directory/04_named.conf.local_servers_fragment_$name":
              ensure => file,
              owner => root,
              group => $bind::group,
              mode => '0644',
              content => template('bind/named.conf.local_servers_fragment.erb'),
              require => File[$bind::named_conf_local_file_fragments_directory],
              notify => Exec[$bind::named_conf_local_file_assemble],
            }
        }
    }
}

