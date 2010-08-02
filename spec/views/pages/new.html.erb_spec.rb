require 'spec_helper'

describe "/pages/new.html.erb" do

  it "should display a form" do
    page = mock_model(Page, :new_record? => true, :valid? => false, :identifier => "some_identifier", :title => "some title", :content => "some content")
    assigns[:page] = page

    render "/pages/new"

    rendered.should have_selector("h1", :content => "Create Page")
    rendered.should have_selector("input", :id => "page_identifier")
    rendered.should have_selector("input", :id => "page_title")
    rendered.should have_selector("textarea", :id => "page_content")
  end

end

