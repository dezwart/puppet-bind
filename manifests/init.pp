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
class bind( $forwarders = undef ) {
	package { 'bind9':
		ensure	=> installed,
	}

	file { '/etc/bind/named.conf.options':
		ensure	=> file,
		owner	=> root,
		group	=> bind,
		mode	=> '0644',
		content	=> template('bind/named.conf.options.erb'),
		require => Package['bind9'],
	}

	service { 'bind9':
		ensure		=> running,
		enable		=> true,
		pattern		=> '/usr/sbin/named',
		restart		=> '/etc/init.d/bind9 reload',
		require		=> Package['bind9'],
		subscribe	=> File['/etc/bind/named.conf.options'],
	}
}
