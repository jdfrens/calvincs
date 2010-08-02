require 'spec_helper'

describe "shared/_subpage.html.erb" do

  it "should textilize the content when not logged in" do
    page = mock_model(Page, :content => "We state our mission.")

    view.should_receive(:page).and_return(page)
    view.should_receive(:current_user).and_return(false)
    expect_textilize("We state our mission.")

    render

    rendered.should contain("We state our mission.")
    rendered.should_not have_selector("h1")
    rendered.should_not have_selector("a", :href=> edit_page_path(page))
  end

  it "should textilize the content and offer edit link when logged in" do
    page = mock_model(Page, :identifier => "foobar", :content => "We state our mission.")

    view.should_receive(:page).at_least(:once).and_return(page)
    view.should_receive(:current_user).and_return(true)
    expect_textilize("We state our mission.")

    render

    rendered.should contain("We state our mission.")
    rendered.should_not have_selector("h1")
    rendered.should have_selector("a", :href=> edit_page_path(page), :content => "edit foobar")
  end

end
