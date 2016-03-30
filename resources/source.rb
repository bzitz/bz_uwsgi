property :version, default: "2.0.12"
property :checksum, default: "306b51db97648d6d23bb7eacd76e5a413434575f220dac1de231c8c26d33e409"
property :uwsgihome, default: "/usr/local/sbin"
property :ini_dir, default: "/usr/local/sbin/uwsgi_ini"

action :build do
  include_recipe 'apt'
  include_recipe 'build-essential::default'

  node.run_state['plugin_dir'] = "#{uwsgihome}/plugins"
  node.run_state['uwsgi_bin'] = "#{uwsgihome}/uwsgi"

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
  
  directory node.run_state['plugin_dir'] do
    action :create
  end

  directory ini_dir do
    action :create
  end
  
  if ::File.exist?("#{node.run_state['uwsgi_bin']}")  
    bz_uwsgi_inventory "get uwsgi version" do
      action :collect
    end
  else
    node.run_state['installed_version'] = nil
  end

  template "/tmp/uwsgi-#{version}/buildconf/core.ini" do
    cookbook "bz_uwsgi"
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
    cookbook "bz_uwsgi"
    source "uwsgi.conf.erb"
    variables(
      :ini_dir => new_resource.ini_dir,
    )
  end

  service "uwsgi" do
    action :start
  end
end
