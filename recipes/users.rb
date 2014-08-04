#
# Cookbook Name:: cobbler
# Recipe:: users
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

# Make cobblerd supports restart notification
service "cobblerd" do
  supports :restart => true
  action :nothing
end
# Make httpd supports restart notification
service "httpd" do
  supports :restart => true
  action :nothing
end

# Update /etc/cobbler/users.conf
cookbook_file "/etc/cobbler/users.conf.sample" do
  source "users.conf.fgusers"
  mode 0644
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[cobblerd]", :immediately
  notifies :restart, "service[httpd]", :immediately
end
