#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
# change since we want the files in here not from installed gem
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require "king_soa"

# this grabs all /soa requests
use KingSoa::Rack::Middleware

#  method to kill this server instance
get '/die' do
  exit!
end

#######################################
# Somewhere in you app define services
#
# setup test registry
service = KingSoa::Service.new(:name=>'soa_test_service', :auth => '12345')
KingSoa::Registry << service

# the local soa class beeing called
class SoaTestService
  def self.perform(param1, param2, param3)
    return [param1, param2, param3]
  end
end