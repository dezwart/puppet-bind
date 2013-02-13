# Bind DNS Server - Acl type
#
#  bind::acl { 'transfer-servers':
#  }
#
define bind::acl( $addresses ) {

  require bind::params

  file { "${bind::params::ncl_ffd}/01_named.conf.local_acl_fragment_${name}":
    ensure  => file,
    owner   => root,
    group   => $bind::group,
    mode    => '0644',
    content => template('bind/named.conf.local_acl_fragment.erb'),
    require => File[$bind::ncl_ffd],
    notify  => Exec[$bind::ncl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
