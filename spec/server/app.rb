#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
# change PATH since we want the files in here not from installed gem
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require "king_soa"

# this grabs all /soa requests
use KingSoa::Rack::Middleware

################################################################################
# Sinatra endpoints
################################################################################

# A non king_soa method => rack middleware is not used
# Still such methods can be called and their result is returned as plain text
post '/non_json_response' do
  "<h1>hello World</h1>"
end

delete "/delete_test" do
  "ereased the sucker"
end

put "/put_test" do
  "put it down"
end

get "/get_test" do
  "go get it"
end

get "/get_with_params_test" do
  str = []
  params.each do |k,v|
    str << "#{k}=>#{v}"
  end
  str.join(', ')
end

# helper method to kill this server instance ins tests
get '/die' do
  exit!
end

################################################################################
# Somewhere in you app you define a local service, receiving the incoming call
#
# setup test registry
service = KingSoa::Service.new(:name=>'soa_test_service', :auth => '12345')
KingSoa::Registry << service

# Local soa class inside this app. Beeing called from remote as a receiver
class SoaTestService
  #simply return all given parameters
  def self.perform(param1, param2, param3)
    return [param1, param2, param3]
  end
end