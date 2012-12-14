#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2012, Skystack Ltd
#
# All rights reserved - Do Not Redistribute
#

group "sys-admin" do
  action :create
  system false
end 

node["groups"].each do |g|

	group g['name'] do
	  action :create
	  system g['is_system']
	end 

	if g['grant_sudo']
  	node.set['authorization']['sudo']['groups'] << g
  end

end

node["users"].each do |u|
  
  if u['home']
  	home_dir = "/home/#{u['username']}"
  elsif u['home_dir']
	home_dir = "#{u['home_dir']}"
  end

  if home_dir
  	manage_home = true
  else 
  	manage_home = false
  end

  if u['shell']
  	user_shell = u['shell']
  else
  	user_shell = node['user']['default']['shell']
  end

  user u['username'] do
    shell user_shell
    comment u['comment']
    supports :manage_home => manage_home
    home home_dir
  end

  group "#{u['username']}" do
  	members "#{u['username']}"
  	append true
  end

  directory "#{home_dir}/.ssh" do
    owner u['username']
    group u['username']
    mode "0700"
  end

  if u['ssh_keys']

    template "#{home_dir}/.ssh/authorized_keys" do
     source "authorised_keys.erb"
     owner u['username']
     group u['username']
     mode "0600"
     variables :ssh_keys => u['ssh_keys']
   end

  end

  if u['is_admin']
  	group "sys-admin" do
  		action :modify
  		members ["#{u['username']}"]
  		append true
	end 
  end

  if u['grant_sudo']
  	node.set['authorization']['sudo']['users'] << u
  end

  execute "passwd -l #{u['username']}"

  	#default['authorization']['sudo']['groups'] = Array.new 
	  #default['authorization']['sudo']['users'] = Array.new

end

#if node['authorization']['sudo']['users'].length > 0 || node['authorization']['sudo']['groups'].length > 0#
#	include_recipe 'users::sudo'
#end

