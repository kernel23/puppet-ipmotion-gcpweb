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

class gcpweb (
  ) {
  $enhancers = [
    'curl',
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
    'letsencrypt',
    'redis-server',
    'phpmyadmin',
    'fail2ban'
    ]

  package { $enhancers: ensure => 'latest' }

  service { ['nginx','php7.0-fpm','redis-server']:
    ensure  => 'running',
    enable  => true,
    require => Package['nginx','php7.0-fpm'],
  }

  class absent_file_exec {
    exec { 'wp-cli download':
    command => '/usr/bin/curl -o /usr/local/bin/wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && /bin/chmod +x /usr/local/bin/wp',
    require => Package['curl'],
    creates => '/usr/local/bin/wp',
    cwd     => '/tmp'
    }
  }

  file { '/etc/nginx/sites-enabled':
    ensure  => 'directory',
    recurse => true,
    purge   => true,
    require => Package['nginx']
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure  => 'link',
    target  => '/etc/nginx/sites-available/default',
    notify  => Service['nginx'],
    require => Package['nginx']
  }
}
