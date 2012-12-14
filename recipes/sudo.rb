package "sudo" do
  action :upgrade
end

template "/etc/sudoers" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :sudoers_groups => node['authorization']['sudo']['groups'], 
    :sudoers_users => node['authorization']['sudo']['users']
  )
end