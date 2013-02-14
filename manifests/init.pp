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
          ) {
  include bind::params

  package { $bind::params::package:
    ensure  => installed,
  }

  file { $bind::params::conf_dir:
    ensure  => directory,
    owner   => root,
    group   => $bind::params::group,
    mode    => '2774',
    require => Package[$bind::params::package],
  }

  file { $bind::params::zone_dir:
    ensure  => directory,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0774',
    require => Package[$bind::params::package],
  }

  file { "${bind::params::conf_dir}/named.conf.options":
    ensure  => file,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0644',
    content => template('bind/named.conf.options.erb'),
    require => [Package[$bind::params::package], File[$bind::params::conf_dir]],
  }

  service { $bind::params::package:
    ensure    => running,
    enable    => true,
    pattern   => '/usr/sbin/named',
    restart   => '/etc/init.d/bind9 reload',
    require   => Package[$bind::params::package],
    subscribe => File['/etc/bind/named.conf.options'],
  }

  # named.conf.local file fragments pattern, purges unmanaged files

  file { $bind::params::ncl:
    ensure  => file,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0640',
    require => [Package[$bind::params::package], File[$bind::params::conf_dir]],
    notify  => Service[$bind::params::service],
  }

  file { $bind::params::ncl_ffd:
    ensure  => directory,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0700',
    require => [Package[$bind::params::package], File[$bind::params::ncl]],
    recurse => true,
    purge   => true,
    notify  => Exec['ncl_file_assemble'],
  }

  exec { $bind::params::ncl_file_assemble:
    refreshonly => true,
    require     => File[$bind::params::ncl_ffd],
    notify      => Service[$bind::params::service],
    command     => "/bin/cat ${bind::params::ncl_ffd}/* > ${bind::params::ncl}",
  }

  file { $bind::params::ncl_preamble:
    ensure  => file,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0600',
    require => Package[$bind::params::package],
    content => template('bind/named.conf.local_preamble.erb'),
    notify  => Exec['ncl_file_assemble'],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
