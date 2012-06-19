# Bind DNS Server
#
# == Parameters
#
# [*forwarders*]
#   Specify one or more recursive forwarders as IP addresses in dotted quad
#   format.
#
# [*dynamic_dns_key*]
#   hmac-md5 key used for dynamic DNS updates. Default is unset.
#
# [*dynamic_dns_forward_zone*]
#   Forward DNS zone for dynamic updates. The zone file contents are unmanaged.
#
# [*dynamic_dns_reverse_zone*]
#   Reverse DNS zone for dynamic updates. The zone file contents are unmanaged.
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
        $dynamic_dns_key = undef,
        $dynamic_dns_forward_zone = undef,
        $dynamic_dns_reverse_zone = undef ) {

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

    if $dynamic_dns_key and $dynamic_dns_forward_zone and $dynamic_dns_reverse_zone {
        file { "$conf_dir/dynamic-dns.key":
            ensure  => file,
            owner   => root,
            group   => $group,
            mode    => '0640',
            content => template('bind/dynamic-dns.key.erb'),
            require => [Package[$package], File[$conf_dir]],
            notify  => Service[$service],
        }

        file { "$conf_dir/named.conf.local":
            ensure  => file,
            owner   => root,
            group   => $group,
            mode    => '0640',
            content => template('bind/named.conf.local.erb'),
            require => [Package[$package], File[$conf_dir]],
            notify  => Service[$service],
        }

        zone_file { [$dynamic_dns_forward_zone, $dynamic_dns_reverse_zone]:
        }
    }
}
