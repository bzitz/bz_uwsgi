property :version, default: node['uwsgi']['version']
property :checksum, default: node['uwsgi']['checksum']

action :create do
  service 'uwsgi' do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true, reload: true
    action :nothing
  end

  include_recipe 'apt'
  include_recipe 'build-essential::default'

  download_url = "http://projects.unbit.it/downloads/uwsgi-#{version}.tar.gz"
  source_pth = "/tmp/uwsgi-#{version}.tar.gz"

  remote_file source_pth do
    checksum new_resource.checksum
    source  download_url
    backup false
  end

  #unpack
  bash "Unpack" do
    cwd "/tmp"
    code <<-EOH
      tar -xzvf #{source_pth} -C .
    EOH
    not_if { ::File.directory?("/tmp/uwsgi-#{version}") }
  end
  
  directory "usr/local/sbin/plugins" do
    action :create
  end
    
  template "/tmp/uwsgi-#{version}/buildconf/core.ini" do
    source "core.ini.erb"
  end

  execute "build core uwsgi" do
    cwd "/tmp/uwsgi-#{version}"
    command "sudo python uwsgiconfig.py --build core"
  end

end

        

