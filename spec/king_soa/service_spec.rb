require File.dirname(__FILE__) + '/../spec_helper.rb'

describe KingSoa::Service do
  before(:each) do
  end

  it "should init" do
    
  end
end

describe KingSoa::Service, 'local request' do

  it "should call service" do
    s = KingSoa::Service.new(:name=>:local_soa_class)
    res = s.execute(1,2,3)
    res.should == [1,2,3]
  end
end

# needs the local testserver !!!
# ruby spec/server/app
describe KingSoa::Service, 'remote request' do

  it "should call a service remote" do
    s = KingSoa::Service.new(:name=>:soa_test_service, :url=>'http://localhost:4567', :auth_key=>'12345')
    s.execute(1,2,3).should == [1,2,3]
  end

  it "should call a service remote and return auth error" do
    s = KingSoa::Service.new(:name=>:soa_test_service, :url=>'http://localhost:4567', :auth_key=>'wrong')
    s.execute(1,2,3).should == "Please provide a valid authentication key"
  end

  it "should call a service remote and return auth error" do
    s = KingSoa::Service.new(:name=>:wrong_service, :url=>'http://localhost:4567', :auth_key=>'12345')
    s.execute(1,2,3).should == "An error occurred! (undefined method `auth_key' for nil:NilClass)"
  end
end


class LocalSoaClass
  def self.execute(param1, param2, param3)
    return [param1, param2, param3]
  end
end