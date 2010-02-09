
# shmmax = kb * 1024 / 3 # one third of ram
# puts "make sure we have enough shmmax"
# Rush.bash "echo #{shmmax} > /proc/sys/kernel/shmmax"

def memory
	node["memory"]["shared"].to_i * 1024
end

def shared_memory 
	memory / 3
end

def current_shared_memory
	File.read("/proc/sys/kernel/shmmax").to_i
end

packages = %w(postgresql-8.4 postgresql-server-dev-8.4 libpq-dev libgeos-dev proj)

packages.each do |p|
	package p do
		action :install
	end
end

service "postgresql"  do
  supports :restart => true, :reload => true
  action :enable
end

execute "setup-shmmax" do
  command "echo #{shared_memory} > /proc/sys/kernel/shmmax"
  action :run
  only_if { shared_memory != current_shared_memory }
end

template "/etc/postgresql/8.4/main/postgresql.conf" do
   source "postgresql.conf.erb"
   mode "0644"
	notifies :restart, resources(:service => "postgresql")
end

