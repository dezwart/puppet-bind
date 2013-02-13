# Bind DNS Server - Masters type
#
#  bind::masters { 'master-servers':
#     addresses => ['172.22.16.20'],
#  }
#
define bind::masters( $addresses ) {
  require bind

  file { "${bind::params::ncl_ffd}/02_named.conf.local_masters_fragment_${name}":
    ensure  => file,
    owner   => root,
    group   => $bind::group,
    mode    => '0644',
    content => template('bind/named.conf.local_masters_fragment.erb'),
    require => File[$bind::ncl_ffd],
    notify  => Exec[$bind::ncl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
