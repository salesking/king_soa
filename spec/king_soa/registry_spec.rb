require File.dirname(__FILE__) + '/../spec_helper.rb'

describe KingSoa::Registry do
  before(:each) do
    @reg = KingSoa::Registry
  end

  it "should return empty services" do
    @reg.services.should == []
  end

  it "should add service" do    
    s = KingSoa::Service.new(:name=>'process_documents')
    @reg << s
    @reg.services.should == [s]
  end

  it "should return a service by name" do
    s = KingSoa::Service.new(:name=>:save_document, :url=>'http://localhost')
    @reg << s
    @reg[:save_document].should == s
  end


end