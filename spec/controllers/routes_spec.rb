require 'spec_helper'

describe HomeController do
  it "should use home controller as root" do
    { :get => "/" }.should route_to(:controller => "home", :action => "index")
  end

  it "should map the Atom feed with an explicit type" do
    { :get => "/feed.atom" }.
      should route_to(:controller => "home", :action => "feed", :format => "atom")
  end

  it "should map the sitemap" do
    { :get => "/sitemap.xml" }.
      should route_to(:controller => "home", :action => "sitemap", :format => "xml")
  end
end

describe PersonnelController do
  user_fixtures
  
  it "should use a person's username" do
    person_path(users(:jeremy)).should == "/people/jeremy"
  end
end

describe UsersController do
  user_fixtures

  it "should use a person's username" do
    user_path(users(:jeremy)).should == "/users/jeremy"
  end

  it "should have a normal edit action" do
    edit_user_path(users(:jeremy)).should == "/users/jeremy/edit"
  end

  it "should have an edit-password action" do
    editpassword_user_path(users(:jeremy)).should == "/users/jeremy/editpassword"
  end
end

describe PagesController do

  it "should recognize page routes" do
    { :get => "/p/foo" }.should route_to(:controller => "pages", :action => "show", :id => 'foo')
  end

  it "should generate page routes" do
    { :get => "/p/foobar" }.
      should route_to(:controller => "pages", :action => "show", :id => 'foobar')
  end

  it "should use /p abbreviation for pages path" do
    pages_path.should == "/p"
  end

  it "should use /p abbreviation path to a page" do
    page = Factory.build(:page, :identifier => "foobar")

    page_path(page).should == "/p/foobar"
  end

end

describe ImagesController do
  it "should recognize list route" do
    { :get => "/pictures" }.
      should route_to(:controller => "images", :action => "index")
  end

  it "should recognize edit route" do
    { :get => "/pictures/8/edit" }.
      should route_to(:controller => "images", :action => "edit", :id => "8")
  end

  it "should recognize a refresh action" do
    { :get => "/pictures/refresh" }.
      should route_to(:controller => "images", :action => "refresh")
  end
end

describe EventsController do
  it "should recognize event path" do
    event = mock_model(Event)
    event_path(event).should == "/events/#{event.id}"
  end
end
