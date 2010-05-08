#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/../../lib/king_soa"
#require "#{File.dirname(__FILE__)}/../../lib/king_soa/rack/middleware"

use KingSoa::Rack::Middleware


#######################################
# Somewhere in you app
#
# setup test registry
service = KingSoa::Service.new(:name=>'soa_test_service', :auth_key=>'12345')
KingSoa::Registry << service

# the class beeing called lokally
class SoaTestService

  def self.execute(param1, param2, param3)
    return [param1, param2, param3]
  end

end