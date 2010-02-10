
memory = node[:memory][:total].to_i * 1024
shared_memory = memory / 3
current_shared_memory = File.read("/proc/sys/kernel/shmmax").to_i

execute "setup-shmmax" do
  command "echo #{shared_memory} > /proc/sys/kernel/shmmax"
  action :run
  only_if { shared_memory != current_shared_memory }
end

template "/etc/postgresql/8.4/main/postgresql.conf" do
  source "postgresql.conf.erb"
  mode "0644"
	variables(
		:ram_mb => memory / 1024 / 1024
	)
end

