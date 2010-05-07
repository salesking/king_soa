require File.dirname(__FILE__) + '/../../spec_helper.rb'

#set :environment, :test

describe KingSoa::Rack::Middleware do
  include Rack::Test::Methods

  before(:each) do
    @service = KingSoa::Service.new(:url=>'localhost', :name=>'a_method')
    KingSoa::Registry << @service
  end
  

  def app
    dummy_app = lambda { |env| puts "in dummy"; [200, {}, ""] }
    KingSoa::Rack::Middleware.new(dummy_app)
  end

  it "says hello" do
    get '/soa', :name=>'a_method', :params=> "#{{:number=>1}.to_json}"
    last_response.should == 'ads'#be_ok
    last_response.body.should == 'Hello World'
  end


end