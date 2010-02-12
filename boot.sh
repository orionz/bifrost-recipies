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
echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/8.4/main/pg_hba.conf 
dpkg -i postgis_1.4.1-src-1_i386.deb
####

echo "waiting for devices to attach"
while [ $(blkid /dev/sde1 /dev/sdf* | wc -l) != 9 ] ; do sleep 1; done

echo -n "assembling raid"
while !  mdadm --assemble /dev/md0 /dev/sdf* ; do echo -n . ; sleep 5 ; done
blockdev --setra 65536 /dev/md0
mkdir /database
mount -L /database /database
echo "done"

mkdir /wal
mount -L /wal /wal

/etc/init.d/postgresql-8.4 start

