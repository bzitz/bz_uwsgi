#
# Cookbook Name:: bz_uwsgi
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

bz_uwsgi_source "test" do
  action :create
  version "2.0.12"
end
