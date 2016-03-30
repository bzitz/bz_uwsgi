bz_uwsgi Cookbook
=================
This cookbook provides one custom resource 'source' that builds uwsgi
core from source, along with python27 and python34 plugins.

Requirements
------------

### Chef
- Chef version 12.5+

### Platforms
- Ubuntu 14.04

### Cookbooks 
- apt
- build-essential

Custom Resources
---------------
- source: The 'source' custom resource compiles uwsgi and installs it in the
  specified directories if the 'inventory' custom resource returns a different 
  version than the version specified when the resource is called.  

### Actions
-   :build - builds uwsgi core and plugins for python2.7 and python 3.4

### Properties

-   :version   - defaults to "2.0.12"
-   :checksum  - defaults to "306b51db97648d6d23bb7eacd76e5a413434575f220dac1de231c8c26d33e409"
                 (must be defined if version is defined)
-   :uwsgihome - defaults to "/usr/local/sbin"
-   :ini_dir   - defaults to "/usr/local/sbin/uwsgi_ini"


### Usage
```ruby
# Compile and install uwsgi
bz_uwsgi_source "Example" do
  action :build
end







