
apt-get update
apt-get upgrade -y
apt-get install ruby irb rubygems ruby-dev git-core -y
gem install rake chef ohai --no-rdoc --no-ri

# git clone git://github.com/orionz/bifrost-recipies.git
# /var/lib/gems/1.8/bin/chef-solo -c config.rb -j bifrost.json 

