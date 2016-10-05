#
# = Class: gcpweb::vhost
#
# [*user*]
# Default undef
#
# [*password*]
# Default "*"
#
# [*vhost*]
# Default undef
#
# [*ssl*]
# Default true
#
# [*shell*]
# Default '/usr/sbin/nologin'


define gcpweb::vhost (
  $user      = undef,
  $password  = '*',
  $shell     = '/bin/bash',
  $vhost     = undef,
  $ssl       = false,
  ) {

  if($vhost) and ($user) {
    user { $user:
      ensure         => 'present',
      home           => "/home/${user}",
      password       => $password,
      shell          => '/usr/sbin/nologin',
      purge_ssh_keys => true,
      managehome     => true,
    }

    file { "/home/${user}/public_html":
      ensure => 'directory',
      owner  => $user,
      group  => $user,
      mode   => '0750',
    }

    if ($ssl) {
      file { "/etc/nginx/sites-available/${user}":
      ensure  => present,
      content => template('gcpweb/vhost_ssl.conf.erb'),
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      require => User[$user],
      notify  => Service['nginx']
      }
    } else {
      file { "/etc/nginx/sites-available/${user}":
      ensure  => present,
      content => template('gcpweb/vhost.conf.erb'),
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      require => User[$user],
      notify  => Service['nginx']
      }
    }

    file { "/etc/nginx/sites-enabled/${user}":
    ensure  => 'link',
    target  => "/etc/nginx/sites-available/${user}",
    require => User[$user]
    }

    file { "/etc/php/7.0/fpm/pool.d/${user}.conf":
    ensure  => present,
    content => template('gcpweb/phpfpm.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => User[$user],
    notify  => Service['php7.0-fpm']
    }
  }
}
