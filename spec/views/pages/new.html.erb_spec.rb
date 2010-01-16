require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/new.html.erb" do

  it "should display a form" do
    page = mock_model(Page, :new_record? => true, :valid? => false, :identifier => "some_identifier", :title => "some title", :content => "some content")
    assigns[:page] = page

    render "/pages/new"

    response.should have_selector("h1", :content => "Create Page")
    response.should have_selector("input", :id => "page_identifier")
    response.should have_selector("input", :id => "page_title")
    response.should have_selector("textarea", :id => "page_content")
  end

end

