require File.dirname(__FILE__) + '/../spec_helper.rb'

describe KingSoa::Service, 'in general' do

  before(:each) do
  end

  it "should not init without name" do
    lambda {
      s = KingSoa::Service.new()
    }.should raise_error
  end

  it "should parse request type from url" do
    s = KingSoa::Service.new(:name=>'get_settings_form', :url=>"GET #{test_url}")
    s.url.should == test_url
    s.request_method.should == :get

    s.url = "DELETE https://whatever"
    s.raw_url.should == "DELETE https://whatever"
    s.url.should == "https://whatever"
    s.request_method.should == :delete

    s.url = "PUT https://localhost:3000"
    s.url.should == "https://localhost:3000"
    s.request_method.should == :put
  end

  it "should parse url with invalid request type" do
    s = KingSoa::Service.new(:name=>'get_settings_form', :url=>"NOWAY #{test_url}")
    s.url.should == test_url
    s.request_method.should be_nil
  end
end

describe KingSoa::Service, 'local request' do
  it "should call service" do
    s = KingSoa::Service.new(:name=>:local_soa_class)
    s.perform(1,2,3).should == [1,2,3]
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

  it "should call remote service and return auth error" do
    s = KingSoa::Service.new(:name=>:soa_test_service, :url=>test_soa_url, :auth=>'wrong')
    s.perform(1,2,3).should == "Please provide a valid authentication key"
  end

  it "should call remote service and return not found error" do
    s = KingSoa::Service.new(:name=>:wrong_service, :url=>test_soa_url, :auth=>'12345')
    s.perform(1,2,3).should include("The service: wrong_service could not be found")
  end

  it "should call remote service without middleware and return plain text" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service, :url=> "#{test_url}/non_json_response")
    s.perform().should == "<h1>hello World</h1>"
  end

  it "should GET remote service with params added to url and return params" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service,
                              :url=> "GET #{test_url}/get_with_params_test",
                              :auth=>'12345' )
    s.request_method.should == :get
    s.perform(:opt_one=>'hi').should == "name=>non_soa_test_service, args=>[{\"opt_one\":\"hi\"}], auth=>12345"
  end

  it "should GET remote service with multiple params" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service,
                              :url=> "GET #{test_url}/get_with_params_test",
                              :auth=>'12345' )
    s.request_method.should == :get
    res = s.perform(:opt_one=>'hi', :opt_two=>'there' )
    res.should include("\"opt_one\":\"hi\"")
    res.should include("\"opt_two\":\"there\"")
  end

  it "should GET remote service and return plain text" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service, :url=> "GET #{test_url}/get_test")
    s.request_method.should == :get
    s.perform().should == "go get it"
  end

  it "should PUT a remote service and return plain text" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service, :url=> "PUT #{test_url}/put_test")
    s.request_method.should == :put
    s.perform().should == "put it down"
  end

  it "should DELETE a remote service and return plain text" do
    s = KingSoa::Service.new(:name=>:non_soa_test_service, :url=> "DELETE #{test_url}/delete_test")
    s.request_method.should == :delete
    s.perform().should == "ereased the sucker"
  end
end# remote request


if redis_running?
  describe KingSoa::Service, 'queued' do

    it "should call queue" do
      s = KingSoa::Service.new(:name=>:local_soa_class, :queue=>:test_queue)
      s.perform(1,2,3).should be_nil
      #...also test for queue content, and remove from redis afterwards

    end
  end
else
  puts "Queued service specs skipped => Unable to connect to Redis on localhost:6379. Come on redis isn't that hard to start"
end