default['authorization']['sudo']['groups'] = Hash.new 
default['authorization']['sudo']['users'] = Hash.new
default['user']['defaults']['shell'] = "/bin/bash"
default['user']['defaults']['is_admin'] = false
default['user']['defaults']['grant_sudo'] = false