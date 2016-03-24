action :build do
  execute "build core uwsgi" do
    cwd "/tmp/uwsgi-#{new_resource.version}"
    command "sudo python uwsgiconfig.py --build core"
  end

  execute "build python27 plugin" do
    cwd "/tmp/uwsgi-#{new_resource.version}"
    command "sudo python2.7 uwsgiconfig.py --plugin plugins/python core python27"
  end
  execute "build pyton34 plugin" do
    cwd "/tmp/uwsgi-#{new_resource.version}"
    command "sudo python3.4 uwsgiconfig.py --plugin plugins/python core python34"
  end
end

