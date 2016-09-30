# puppet-ipmotion-gcpweb

#Overview

This is specific dev for https://ipmotion.ca hosting project at Google Cloud Platform.
You should not use this until you know exactly what you are doing ...

        Compute Engine
        VM instances
        Ubuntu 16.04.1 LTS xenial

##Usage

Create and configure a basic vhost for a node :

        node "ubuntu-xenial-1.c.ipmotion-lab.internal" {
          class { "gcpweb":
            vhost    =>  ['example.org','www.example.org'],
            user     => 'example',
            password => '*',
            ssl      => false
          }
        }
