require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'king_soa'
require 'spec'
require 'spec/autorun'
# for mocking web requests
require 'webmock/rspec'
require 'rack/test'
include WebMock



def local_service
#         Rack::Builder.app do
#      use KingSoa::Rack::Middleware
#      run super
#    end

#    Rack::Builder.new do
#    use KingSoa::Rack::Middleware
#    app = proc do |env|
#    [ 200, {'Content-Type' => 'text/plain'}, "b" ]
#    end
#    run app
#    end.to_app
#    def app
#      Rack::Builder.new {
#        # URLs starting with /account (logged in users) go to Rails
#        map "/soa" do
#          run KingSoa::Rack::Middleware.new
#        end
#      }.to_app
#    end
#    app.run
end