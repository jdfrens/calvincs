require 'spec_helper'

describe MenuItem do
  describe "simple menu item" do
    before(:each) do
      @menu_item = MenuItem.new("foo", "/foobar")
    end
    
    it "should render text" do  
      @menu_item.text.should == "foo"
    end
    
    it "should render path" do
      @menu_item.path.should == "/foobar"
    end
    
    it "should render popup text" do
      @menu_item.popup.should == "foo"
    end
  end
  
  describe "override popup" do
    before(:each) do
      @menu_item = MenuItem.new("foo", "/foobar", :popup => "Yo!")
    end
    
    it "should render popup text" do
      @menu_item.popup.should == "Yo!"
    end
  end
  
  describe "active or not" do
    before(:each) do
      @request = mock("the request", :fullpath => "/does/not/match")
      @params = {}
    end
    
    it "should not be active by default" do
      @request.should_receive(:fullpath).and_return("/abc123")
      
      MenuItem.new("foo", "/foobar").active?(@params, @request).should be_false
    end
    
    it "should be active when on the menu-item's page" do
      @request.should_receive(:fullpath).and_return("/foobar")

      MenuItem.new("foo", "/foobar").active?(@params, @request).should be_true
    end
    
    it "should be active by method" do
      MenuItem.new("foo", "/foobar", :active => lambda { |p| true }).
        active?(@params, @request).should be_true
    end
  end
end
