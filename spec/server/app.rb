#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/../../lib/king_soa"

use KingSoa::Rack::Middleware


###################################################
# method to kill this server instance
#'/die'
#######################################
# Somewhere in you app
#
# setup test registry
service = KingSoa::Service.new(:name=>'soa_test_service', :auth_key=>'12345')
KingSoa::Registry << service

# the class beeing called localy
class SoaTestService

  def self.perform(param1, param2, param3)
    return [param1, param2, param3]
  end

end