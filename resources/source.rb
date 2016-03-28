property :version, default: node['uwsgi']['version']
property :checksum, default: node['uwsgi']['checksum']

action :create do
  include_recipe 'apt'
  include_recipe 'build-essential::default'

  service 'uwsgi' do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true, reload: true
    action :nothing
  end
  
  package "python-dev" 
  package "python3-dev" 

  download_url = "http://projects.unbit.it/downloads/uwsgi-#{version}.tar.gz"
  source_pth = "/tmp/uwsgi-#{version}.tar.gz"

  remote_file source_pth do
    checksum new_resource.checksum
    source  download_url
    backup false
    not_if { ::File.directory?(source_pth) }
  end

  #unpack
  bash "Unpack" do
    cwd "/tmp"
    code <<-EOH
      tar -xzvf #{source_pth} -C .
    EOH
    not_if { ::File.directory?("/tmp/uwsgi-#{version}") }
  end
  
  directory node['uwsgi']['plugin_dir'] do
    action :create
  end

  directory node['uwsgi']['ini_dir'] do
    action :create
  end
  
  if ::File.exist?("#{node['uwsgi']['binary']}")  
    bz_uwsgi_inventory "get uwsgi version" do
      action :collect
    end
  else
    node.run_state['installed_version'] = nil
  end

  template "/tmp/uwsgi-#{version}/buildconf/core.ini" do
    source "core.ini.erb"
  end

  bz_uwsgi_build "Build Core with Plugins" do
    action :build
    version version
    notifies :restart, 'service[uwsgi]'
    not_if do
      node.run_state['installed_version'] == version
    end
  end

  template "/etc/init/uwsgi.conf" do
    source "uwsgi.conf.erb"
  end

  service "uwsgi" do
    action :start
  end
end
