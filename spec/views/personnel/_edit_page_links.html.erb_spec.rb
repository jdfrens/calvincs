require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/_edit_page_links.html.erb" do
  it "should render edit and delete links" do
    assigns[:user] = user = mock_model(User)

    template.should_receive(:page_type).at_least(:once).and_return("foobar")
    user.should_receive(:page_identifier).with("foobar").
            at_least(:once).and_return("foobar identifier")

    render "personnel/_edit_page_links"

    response.should have_selector("a", :href => edit_page_path("foobar identifier"), :content => "edit foobar")
    response.should have_selector("a", :href => page_path("foobar identifier"), :content => "delete foobar")
  end
end
