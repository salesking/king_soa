require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe KingSoa::Rack::Middleware do
  include Rack::Test::Methods

  before(:each) do
    @service = KingSoa::Service.new(:url=>'localhost', :name=>'a_method')
    KingSoa::Registry << @service
  end

  it "should handle exceptions" do
    app = stub("ApplicationStub").as_null_object
    middleware = KingSoa::Rack::Middleware.new(app)
    env = {"PATH_INFO" => "/soa", "name" => 'a_method'}

    rack_response = middleware.call env
    rack_response.first.should == 500 #status code
    rack_response.last.should be_a_kind_of(Array)
    rack_response.last.first.should == "{\"error\":\"An error occurred! (Missing rack.input)\"}"
  end

  xit "should handle result" do
    app = stub("ApplicationStub").as_null_object
    middleware = KingSoa::Rack::Middleware.new(app)
    env = {"PATH_INFO" => "/soa"}
#    KingSoa.should_receive(:find).and_return(@service)
  end
end