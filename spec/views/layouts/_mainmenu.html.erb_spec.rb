require 'spec_helper'

describe "layouts/_mainmenu.html.erb" do
  before(:each) do
    view.stub(:events_submenu?).and_return(false)
    view.stub(:newsitems_submenu?).and_return(false)
  end

  it "should render menu" do
    render
    
    rendered.should have_selector("ul") do |list|
      list.should have_selector("li", :content => "Home")
    end
  end
  
  context "not on a special page" do
    it "should not have event submenu" do
      render
      
      rendered.should_not have_selector("li", :content => "Current")
      rendered.should_not have_selector("li", :content => "Archive")
    end
  end
  
  context "on an event page" do
    it "should have event submenu" do
      view.should_receive(:events_submenu?).at_least(:once).and_return(true)
      
      render
    
      rendered.should have_selector("li", :content => "Events") do |list|
        list.should have_selector("li", :content => "Current")
        list.should have_selector("li", :content => "Archive")
      end
    end
  end
  
  context "on a newsitem page" do
    it "should have event submenu" do
      view.should_receive(:newsitems_submenu?).at_least(:once).and_return(true)
      
      render
    
      rendered.should have_selector("li", :content => "News") do |list|
        list.should have_selector("li", :content => "Current")
        list.should have_selector("li", :content => "Archive")
      end
    end
  end
end
