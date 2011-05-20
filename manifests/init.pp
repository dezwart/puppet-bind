# Bind DNS Server
#
# == Parameters
#
# [*forwarders*]
#   Specify one or more recursive forwarders as IP addresses in dotted quad
#   format.
#
# [*dynamic_dns_key*]
#   hmac-md5 key used for dynamic DNS updates. Default is unset.
#
# [*dynamic_dns_forward_zone*]
#   Forward DNS zone for dynamic updates. The zone file contents are unmanaged.
#
# [*dynamic_dns_reverse_zone*]
#   Reverse DNS zone for dynamic updates. The zone file contents are unmanaged.
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
		$dynamic_dns_key = undef,
		$dynamic_dns_forward_zone = undef,
		$dynamic_dns_reverse_zone = undef ) {
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

	if $dynamic_dns_key {
		file { '/etc/bind':
			ensure	=> directory,
			owner	=> root,
			group	=> bind,
			mode	=> '2774',
		}
			
		file { '/etc/bind/dynamic-dns.key':
			ensure	=> file,
			owner	=> root,
			group	=> bind,
			mode	=> '0640',
			content	=> template('bind/dynamic-dns.key.erb'),
			require	=> Package['bind9'],
			notify	=> Service['bind9'],
		}

		file { '/etc/bind/named.conf.local':
			ensure	=> file,
			owner	=> root,
			group	=> bind,
			mode	=> '0640',
			content	=> template('bind/named.conf.local.erb'),
			require	=> Package['bind9'],
			notify	=> Service['bind9'],
		}

		file { "/etc/bind/db.$dynamic_dns_forward_zone":
			ensure	=> file,
			owner	=> root,
			group	=> bind,
			mode	=> '0660',
			require	=> Package['bind9'],
			notify	=> Service['bind9'],
		}

		file { "/etc/bind/db.$dynamic_dns_reverse_zone":
			ensure	=> file,
			owner	=> root,
			group	=> bind,
			mode	=> '0660',
			require	=> Package['bind9'],
			notify	=> Service['bind9'],
		}
	}
}
