# Bind DNS Server - Masters type
#
#  bind::masters { 'master-servers':
#     addresses => ['172.22.16.20'],
#  }
#
define bind::masters( $addresses ) {
  require bind::params

  $fragment_pfx = '02_named.conf.local_masters_fragment_'

  file { "${bind::params::ncl_ffd}/${fragment_pfx}${name}":
    ensure  => file,
    owner   => root,
    group   => $bind::params::group,
    mode    => '0644',
    content => template('bind/named.conf.local_masters_fragment.erb'),
    require => File[$bind::params::ncl_ffd],
    notify  => Exec[$bind::params::ncl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
