require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'king_soa'
require 'spec'
require 'spec/autorun'
require 'rack/test'
# for starting the test sinatra server
require 'open3'

def test_url
  'http://localhost:4567'
end

# Start a local test sinatra app receiving the real requests .. no mocking here
# the server could also be started manually with:
#   ruby spec/server/app
def start_test_server(wait_time=1)
  # start sinatra test server
  Dir.chdir(File.dirname(__FILE__) + '/server/') do
    @in, @rackup, @err = Open3.popen3("ruby app.rb")
  end
  sleep wait_time # ensure the server is up
end

def stop_test_server
  Typhoeus::Request.get( "#{test_url}/die")
end

################################################################################
# Local soa classes called in specs
################################################################################

class LocalSoaClass
  def self.perform(param1, param2, param3)
    return [param1, param2, param3]
  end
end