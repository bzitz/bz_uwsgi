action :collect do
  uwsgi_version = Mixlib::ShellOut.new("./uwsgi --version", :cwd => '/usr/local/sbin')
  uwsgi_version.run_command

  node.run_state['installed_version'] = uwsgi_version.stdout.chomp
#  node.run_state['installed_version'] = "Your Mom"
end
