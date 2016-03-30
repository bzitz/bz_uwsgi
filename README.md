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
-   :build  :  builds uwsgi core and plugins for python2.7 and python 3.4

### Properties
Attributes can be defined in the attributes file of the wrapper cookbook or when 
calling the custom resource. See usage for examples.  

-   :version  : defaults to node['uwsgi']['version']
-   :checksum : defaults to node['uwsgi']['checksum']



