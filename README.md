# puppet-ipmotion-gcpweb

##Overview

This is specific dev for https://ipmotion.ca hosting project at Google Cloud Platform.
You should not use this until you know exactly what you are doing ...

        Compute Engine
        VM instances
        Ubuntu 16.04.1 LTS xenial

##Memo

        # apt-get install puppet
        # git clone https://github.com/kernel23/puppet-ipmotion-gcpweb
        # puppet module build .
        # puppet module install ipmotion-gcpweb-0.0.1.tar.gz

##Usage

To create and configure a basic vhost for your node (site.pp):

        node "ubuntu-xenial-1.c.ipmotion-lab.internal" {
          class { "gcpweb":
            vhost    =>  ['example.org','www.example.org'],
            user     => 'example',
            password => '*',
            ssl      => false
          }
        }

##Run

        puppet apply /etc/puppet/manifests/site.pp --verbose --test

