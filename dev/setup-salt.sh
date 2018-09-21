#!/bin/sh
curl -L https://bootstrap.saltstack.com | sudo sh -s -- git develop
# setup top files to test the formula
sudo mkdir -p /srv/pillar
sudo ln -s /srv/salt/pillar.example /srv/pillar/os-hardening.sls
sudo ln -s /srv/salt/dev/pillar_top.sls /srv/pillar/top.sls
# this file will be copied to make a running config. it should not be checked in.
sudo cp /srv/salt/dev/state_top.sls /srv/salt/top.sls
# Accept all keys#
sleep 15 #give the minion a few seconds to register
sudo salt-key -y -A
