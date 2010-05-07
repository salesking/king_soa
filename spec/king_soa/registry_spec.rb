require File.dirname(__FILE__) + '/../spec_helper.rb'

describe KingSoa::Registry do
  before(:each) do

  end

  it "should return empty services" do
    reg = KingSoa::Registry.new
    reg.services.should == []
  end

  it "should add service" do
    reg = KingSoa::Registry.new
    s = KingSoa::Service.new(:url=>'http://localhost')
    reg << s
    reg.services.should == [s]
  end

  it "should return a service by name" do
    reg = KingSoa::Registry.new
    s = KingSoa::Service.new(:name=>:save_document, :url=>'http://localhost')
    reg << s
    reg[:save_document].should == s
  end


end