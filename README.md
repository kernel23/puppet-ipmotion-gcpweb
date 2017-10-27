# puppet-ipmotion-gcpweb

## Overview

This is specific dev for https://ipmotion.ca hosting project at Google Cloud Platform.
You should not use this until you know exactly what you are doing ...

        Compute Engine
        VM instances
        Ubuntu 16.04.1 LTS xenial


## Memo

        # apt-get install puppet
        # git clone https://github.com/kernel23/puppet-ipmotion-gcpweb
        # puppet module build puppet-ipmotion-gcpweb
        # puppet module install puppet-ipmotion-gcpweb/pkg/ipmotion-gcpweb-0.0.1.tar.gz

## Usage with node files

To create and configure a basic vhost for your node (site.pp):

        node "instance-1.c.ipmotion-wp.internal" {
          class { "gcpweb":
          }
          gcpweb::vhost { 'example':
            vhost    =>  ['example.org','www.example.org'],
            user     => 'example',
            ssl      => false
          }
          gcpweb::vhost { 'example2':
            vhost    =>  ['example2.org','www.example2.org'],
            user     => 'example2',
            ssl      => false
          }

## Run in masterless mode

        puppet apply /etc/puppet/manifests/site.pp --verbose --test


## Usage with Hiera (YAML)

        ---
        vhosts:
          test.ca:
            vhost: [test.ca' ,'www.test.ca']
            user: 'test'
            ssl : true
            enable: true
