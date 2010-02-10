#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install git-core xfsprogs mdadm -y
apt-get install postgresql-8.4 postgresql-server-dev-8.4 libpq-dev libgeos-dev proj -y
/etc/init.d/postgresql-8.4 stop

### all this does not is write the configuration file + install postgis.deb
cd /tmp/
git clone git://github.com/orionz/bifrost-recipies.git
cd bifrost-recipies
apt-get install ruby irb rubygems ruby-dev libopenssl-ruby -y
gem install rake chef ohai --no-rdoc --no-ri
/var/lib/gems/1.8/bin/chef-solo -c config.rb -j bifrost.json
dpkg -i postgis_1.4.1-src-1_i386.deb
####

mdadm --assemble /dev/md0 /dev/sde2 /dev/sde1
blockdev --setra 65536 /dev/md0
mkdir /database
mkdir /wal
mount -L /database /database
mount -L /wal /wal

/etc/init.d/postgresql-8.4 start

