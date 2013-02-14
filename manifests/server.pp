# Bind DNS Server - Server type
#
#  bind::server { '172.22.16.21':
#     key => 'TRANSFER',
#  }
#
define bind::server( $key = undef ) {
  require bind::params

  $fragment_pfx = '04_named.conf.local_servers_fragment_'

  file { "${bind::params::ncl_ffd}/${fragment_pfx}${name}":
    ensure  => file,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0644',
    content => template('bind/named.conf.local_servers_fragment.erb'),
    require => File[$bind::params::ncl_ffd],
    notify  => Exec[$bind::params::ncl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
