require File.dirname(__FILE__) + '/../spec_helper.rb'

describe KingSoa::Service, 'in general' do

  before(:each) do
  end

  it "should not init without name" do
    lambda {
      s = KingSoa::Service.new()
    }.should raise_error
  end
end

describe KingSoa::Service, 'local request' do
  it "should call service" do
    s = KingSoa::Service.new(:name=>:local_soa_class)
    s.perform(1,2,3).should == [1,2,3]
  end
end

describe KingSoa::Service, 'queued' do

  it "should call queue" do
    s = KingSoa::Service.new(:name=>:local_soa_class, :queue=>:test_queue)
    s.perform(1,2,3).should be_nil
  end
end

describe KingSoa::Service, 'remote request' do
  before :all do
    start_test_server
  end

  after :all do
    stop_test_server
  end

  it "should call a remote service" do
    s = KingSoa::Service.new(:name=>:soa_test_service, :url=>test_soa_url, :auth=>'12345')
    s.perform(1,2,3).should == [1,2,3]
  end

  it "should call a remote service and return auth error" do
    s = KingSoa::Service.new(:name=>:soa_test_service, :url=>test_soa_url, :auth=>'wrong')
    s.perform(1,2,3).should == "Please provide a valid authentication key"
  end

  it "should call a service remote and return not found error" do
    s = KingSoa::Service.new(:name=>:wrong_service, :url=>test_soa_url, :auth=>'12345')
    s.perform(1,2,3).should include("The service: wrong_service could not be found")
  end

  it "should call a remote service without using middleware and returning plain text" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service, :url=> "#{test_url}/non_json_response")
    s.perform().should == "<h1>hello World</h1>"
  end
end