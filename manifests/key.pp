# Bind DNS Server - Key type
#
#  bind::key { 'TRANSFER':
#     algorithm => '',
#     secret => '',
#  }
#
define bind::key( $algorithm, $secret ) {
  require bind::params

  file { "${bind::params::ncl_ffd}/03_named.conf.local_key_fragment_${name}":
    ensure  => file,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0644',
    content => template('bind/named.conf.local_key_fragment.erb'),
    require => File[$bind::params::ncl_ffd],
    notify  => Exec[$bind::params::ncl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
