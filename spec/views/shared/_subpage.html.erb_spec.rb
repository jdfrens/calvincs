require 'spec_helper'

describe "/shared/_subpage.html.erb" do

  it "should textilize the content when not logged in" do
    page = mock_model(Page, :content => "We state our mission.")

    template.should_receive(:current_user).and_return(false)
    expect_textilize("We state our mission.")

    render "shared/_subpage", :locals => { :page => page }

    response.should contain("We state our mission.")
    response.should_not have_selector("h1")
    response.should_not have_selector("a", :href=> edit_page_path(page))
  end

  it "should textilize the content and offer edit link when logged in" do
    page = mock_model(Page, :identifier => "foobar", :content => "We state our mission.")

    template.should_receive(:current_user).and_return(true)
    expect_textilize("We state our mission.")

    render "shared/_subpage", :locals => { :page => page }

    response.should contain("We state our mission.")
    response.should_not have_selector("h1")
    response.should have_selector("a", :href=> edit_page_path(page), :content => "edit foobar")
  end

end
