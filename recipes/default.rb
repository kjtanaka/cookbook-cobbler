#
# Cookbook Name:: cobbler
# Recipe:: default
# Author:: Koji Tanaka (<kj.tanaka@gmail.com>)
#
# Copyright 2014, FutureGrid, Indiana University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install EPEL repository
include_recipe 'yum-epel'
# Disable iptables
include_recipe 'iptables::disabled'
# Disable SELinux
include_recipe 'selinux::disabled'

# Setup variables
server = node['cobbler']['server']
next_server = node['cobbler']['next_server']
password = node['cobbler']['password']
module_authentication = node['cobbler']['module_authentication']
module_authorization = node['cobbler']['module_authorization']

# Install packages
package "cobbler"
package "cobbler-web"
package "pykickstart"
package "cman"
package "wget"

# Enable Services
enable_services = %w[cobblerd httpd xinetd]

enable_services.each do |enable_service|
  service "#{enable_service}" do
    action [:start, :enable]
  end
end

# Update /etc/xinetd.d/rsync
cookbook_file "/etc/xinetd.d/rsync" do
  source "rsync"
  mode 0644
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[xinetd]", :immediately
end

# Cobbler Sync
execute "cobbler_sync" do
  command "cobbler sync"
  action :nothing
end

# Cobbler Get Loaders
execute "cobbler_get-loaders" do
  command "cobbler get-loaders"
  action :nothing
end

# Update /etc/cobbler/settings
template "/etc/cobbler/settings" do
  source "settings.erb"
  mode 0644
  owner "root"
  group "root"
  action :create
  variables(
    :server => server,
    :next_server => next_server,
    :password => password
  )
  notifies :restart, "service[cobblerd]", :immediately
  notifies :run, "execute[cobbler_sync]", :immediately
  notifies :run, "execute[cobbler_get-loaders]", :immediately
end

# Update /etc/cobbler/modules.conf
template "/etc/cobbler/modules.conf" do
  source "modules.conf.erb"
  mode 0644
  owner "root"
  group "root"
  action :create
  variables(
    :module_authentication => module_authentication,
    :module_authorization => module_authorization
  )
  notifies :restart, "service[cobblerd]", :immediately
  notifies :restart, "service[httpd]", :immediately
end

