require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe KingSoa::Rack::Middleware do
  include Rack::Test::Methods

  before(:each) do
    @service = KingSoa::Service.new(:url=>'localhost', :name=>'a_method')
    KingSoa::Registry << @service
  end

  it "should be able to handle exceptions" do
    app = stub("ApplicationStub").as_null_object
    middleware = KingSoa::Rack::Middleware.new(app)
    env = {"PATH_INFO" => "/soa", "name" => 'a_method'}

    rack_response = middleware.call env
    rack_response.first.should == 500 #status code
    rack_response.last.should be_a_kind_of(Array)
    rack_response.last.first.should == "{\"error\":\"An error occurred! (Missing rack.input)\"}"
  end

  xit "says hello" do
    app = stub("ApplicationStub").as_null_object
        middleware = Hoth::Providers::RackProvider.new(app)

    get '/soa', :name=>'a_method', :params=> "#{{:number=>1}.to_json}"
    last_response.should == 'ads'#be_ok
    last_response.body.should == 'Hello World'
  end

#  def app
#    dummy_app = lambda { |env| puts "in dummy"; [200, {}, ""] }
#    KingSoa::Rack::Middleware.new(dummy_app)
#  end

end