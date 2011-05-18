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
