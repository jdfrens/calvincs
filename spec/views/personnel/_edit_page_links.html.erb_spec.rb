require 'spec_helper'

describe "personnel/_edit_page_links.html.erb" do
  it "should render create link" do
    user = mock_model(User)
    assign(:user, user)

    view.should_receive(:page_type).at_least(:once).and_return("foobar")
    user.should_receive(:page_identifier).with("foobar").
            at_least(:once).and_return("foobar identifier")
    user.should_receive(:subpage).with("foobar").
            at_least(:once).and_return(nil)

    render

    rendered.should have_selector("a", :href => edit_page_path("foobar identifier"), :content => "create foobar")
    rendered.should_not contain("edit foobar")
    rendered.should_not contain("delete foobar")
  end

  it "should render edit and delete links" do
    user = mock_model(User)
    assign(:user, user)
    page = mock_model(Page)

    view.should_receive(:page_type).at_least(:once).and_return("foobar")
    user.should_receive(:page_identifier).with("foobar").
            at_least(:once).and_return("foobar identifier")
    user.should_receive(:subpage).with("foobar").
            at_least(:once).and_return(page)

    render

    rendered.should have_selector("a", :href => edit_page_path("foobar identifier"), 
                                       :content => "edit foobar")
    rendered.should have_selector("a", :href => page_path("foobar identifier"), 
                                       :content => "delete foobar")
    rendered.should_not contain("create foobar")
  end
end
