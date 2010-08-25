require 'spec_helper'

describe "layouts/_mainmenu.html.erb" do
  before(:each) do
    view.stub(:events_submenu?).with(anything).and_return(false)
    view.stub(:newsitems_submenu?).with(anything).and_return(false)
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
end
