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
      @params = {}
      @request = mock("the request", :fullpath => "/does/not/match")
      @template = mock("template", :params => @params)
      @template.stub_chain(:controller, :request).and_return(@request)
    end
    
    it "should not be active by default" do
      @request.should_receive(:fullpath).and_return("/abc123")
      
      MenuItem.new("foo", "/foobar").active?(@template).should be_false
    end
    
    it "should be active when on the menu-item's page" do
      @request.should_receive(:fullpath).and_return("/foobar")

      MenuItem.new("foo", "/foobar").active?(@template).should be_true
    end
    
    it "should be active by method" do
      MenuItem.new("foo", "/foobar", :active => lambda { |p| true }).
        active?(@template).should be_true
    end
    
    it "should be active because of active submenu" do
      submenu_item = mock("submenu item")
      
      submenu_item.should_receive(:active?).with(@template).and_return(true)
      
      MenuItem.new("foo", "/foobar", :submenu_items => [submenu_item]).
        active?(@template).should be_true
    end

    it "should be active because of an active submenu" do
      submenu_items = [mock("item 0"), mock("item 1"), mock("item 2")]
      
      submenu_items[0].stub(:active?).with(@template).and_return(false)
      submenu_items[1].stub(:active?).with(@template).and_return(true)
      submenu_items[2].stub(:active?).with(@template).and_return(false)
      
      MenuItem.new("foo", "/foobar", :submenu_items => submenu_items).
        active?(@template).should be_true
    end
  end
  
  describe "has submenu?" do
    it "should not have submenu by default" do
      MenuItem.new("foo", "/foobar").has_submenu?.should be_false
    end

    it "should have submenu when submenu item is provided" do
      MenuItem.new("foo", "/foobar", :submenu_items => [mock("submenu item")]).
        has_submenu?.should be_true
    end

    it "should have submenu when submenu items are provided" do
      MenuItem.new("foo", "/foobar", 
        :submenu_items => [mock("submenu item"), mock("submenu item"), mock("submenu item")]).
        has_submenu?.should be_true
    end
  end
end
