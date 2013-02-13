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
            $transfer_servers = undef,
            $mode = 'master',
            $allow_query = undef,
          ) inherits bind::params {

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

  file { $zone_dir:
    ensure  => directory,
    owner   => root,
    group   => $group,
    mode    => '0774',
    require => Package[$package],
  }

  file { "${conf_dir}/named.conf.options":
    ensure  => file,
    owner   => root,
    group   => $group,
    mode    => '0644',
    content => template('bind/named.conf.options.erb'),
    require => [Package[$package], File[$conf_dir]],
  }

  service { $package:
    ensure    => running,
    enable    => true,
    pattern   => '/usr/sbin/named',
    restart   => '/etc/init.d/bind9 reload',
    require   => Package[$package],
    subscribe => File['/etc/bind/named.conf.options'],
  }

  # named.conf.local file fragments pattern, purges unmanaged files

  file { $ncl:
    ensure  => file,
    owner   => root,
    group   => $group,
    mode    => '0640',
    require => [Package[$package], File[$conf_dir]],
    notify  => Service[$service],
  }

  file { $ncl_ffd:
    ensure  => directory,
    owner   => root,
    group   => $group,
    mode    => '0700',
    require => [Package[$package], File[$ncl]],
    recurse => true,
    purge   => true,
    notify  => Exec['ncl_file_assemble'],
  }

  exec { $ncl_file_assemble:
    refreshonly => true,
    require     => File[$ncl_ffd],
    notify      => Service[$service],
    command     => "/bin/cat ${ncl_ffd}/*_named.conf.local_* > ${ncl}",
  }

  file { $ncl_preamble:
    ensure  => file,
    owner   => root,
    group   => $group,
    mode    => '0600',
    require => Package[$package],
    content => template('bind/named.conf.local_preamble.erb'),
    notify  => Exec['ncl_file_assemble'],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
