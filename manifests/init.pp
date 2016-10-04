#
# = Class: gcpweb
#
# Install and configure a basic web server.
#
# This is specific dev for https://ipmotion.ca
# hosting project at Google Cloud Platform. You
# should not use this until you know exactly
# what you are doing ...
#
# * Compute Engine / VM instances (Ubuntu 16.04.1 LTS xenial)
# * Configure nginx
# * Configure php7.0-fpm
# * Add user:group
# * Create vhost (optional ssl with letsencrypt)
# 
# To do :
#
# * SSH keys
#
# == Parameters
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


class gcpweb (
  $user      = undef,
  $password  = '*',
  $shell     = '/usr/sbin/nologin',
  $vhost     = undef,
  $ssl       = true,
  ) {

# (1) Configure server
  $enhancers = [
    'nginx',
    'php-common',
    'php-fpm',
    'php-gd',
    'php-gettext',
    'php-mbstring',
    'php-mcrypt',
    'php-mysql',
    'php-pear',
    'php-phpseclib',
    'php-tcpdf',
    'php-xml',
    'php7.0-cli',
    'php7.0-common',
    'php7.0-fpm',
    'php7.0-gd',
    'php7.0-json',
    'php7.0-mbstring',
    'php7.0-mcrypt',
    'php7.0-mysql',
    'php7.0-opcache',
    'php7.0-readline',
    'php7.0-xml',
    'letsencrypt'
    ]

  package { $enhancers: ensure => 'latest' }

  if($vhost) and ($user) {
    service { ['nginx','php7.0-fpm']:
    ensure => running,
    enable => true
    }
  } else {
    service { ['nginx','php7.0-fpm']:
    ensure => stopped,
    enable => false
    }
  }

# (2) Configure user
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

    if defined(Package['phpmyadmin']) {
      file { "/home/${user}/public_html/phpmyadmin":
      ensure => 'link',
      target => '/usr/share/phpmyadmin',
      }
    } else {
      file { "/home/${user}/public_html/phpmyadmin":
      ensure => 'absent',
      }
    }
  }

# (3) Configure vhost + php-fpm pool
  file { '/etc/nginx/sites-enabled':
    ensure  => 'directory',
    recurse => true,
    purge   => true,
    require => Package[$enhancers]
  }

  if($vhost) and ($user) {
    if ($ssl) {
      file { "/etc/nginx/sites-available/${user}":
      ensure  => present,
      content => template('gcpweb/vhost_ssl.conf.erb'),
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Service['nginx'],
      require => Package[$enhancers]
      }
    } else {
      file { "/etc/nginx/sites-available/${user}":
      ensure  => present,
      content => template('gcpweb/vhost.conf.erb'),
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Service['nginx'],
      require => Package[$enhancers]
      }
    }

    file { "/etc/nginx/sites-enabled/${user}":
    ensure  => 'link',
    target  => "/etc/nginx/sites-available/${user}",
    require => Package[$enhancers]
    }

    file { "/etc/php/7.0/fpm/pool.d/${user}.conf":
    ensure  => present,
    content => template('gcpweb/phpfpm.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Service['php7.0-fpm'],
    require => Package[$enhancers]
    }
  }

  file { '/etc/nginx/sites-enabled/default':
  ensure  => 'link',
  target  => '/etc/nginx/sites-available/default',
  require => Package[$enhancers]
  }
}
