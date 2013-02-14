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
  $cn = 'bind'
  $package = "${cn}9"
  $service = "${cn}9"
  $user = $cn
  $group = $cn
  $conf_dir = "/etc/${cn}"
  $zone_dir = "/var/lib/${cn}"
  $ncl = "${conf_dir}/named.conf.local"
  $ncl_ffd = "${ncl}.d"
  $ncl_file_assemble = 'ncl_file_assemble'
  $ncl_preamble = "${ncl_ffd}/00_named.conf.local_preamble"

  package { $bind::package:
    ensure  => installed,
  }

  file { $bind::conf_dir:
    ensure  => directory,
    owner   => root,
    group   => $bind::group,
    mode    => '2774',
    require => Package[$bind::package],
  }

  file { $bind::zone_dir:
    ensure  => directory,
    owner   => root,
    group   => $bind::group,
    mode    => '0774',
    require => Package[$bind::package],
  }

  file { "${bind::conf_dir}/named.conf.options":
    ensure  => file,
    owner   => root,
    group   => $bind::group,
    mode    => '0644',
    content => template('bind/named.conf.options.erb'),
    require => [Package[$bind::package], File[$bind::conf_dir]],
  }

  service { $bind::package:
    ensure    => running,
    enable    => true,
    pattern   => '/usr/sbin/named',
    restart   => '/etc/init.d/bind9 reload',
    require   => Package[$bind::package],
    subscribe => File['/etc/bind/named.conf.options'],
  }

  # named.conf.local file fragments pattern, purges unmanaged files

  file { $bind::ncl:
    ensure  => file,
    owner   => root,
    group   => $bind::group,
    mode    => '0640',
    require => [Package[$bind::package], File[$bind::conf_dir]],
    notify  => Service[$bind::service],
  }

  file { $bind::ncl_ffd:
    ensure  => directory,
    owner   => root,
    group   => $bind::group,
    mode    => '0700',
    require => [Package[$bind::package], File[$bind::ncl]],
    recurse => true,
    purge   => true,
    notify  => Exec['ncl_file_assemble'],
  }

  exec { $bind::ncl_file_assemble:
    refreshonly => true,
    require     => File[$bind::ncl_ffd],
    notify      => Service[$bind::service],
    command     => "/bin/cat ${bind::ncl_ffd}/* > ${bind::ncl}",
  }

  file { $bind::ncl_preamble:
    ensure  => file,
    owner   => root,
    group   => $bind::group,
    mode    => '0600',
    require => Package[$bind::package],
    content => template('bind/named.conf.local_preamble.erb'),
    notify  => Exec['ncl_file_assemble'],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
