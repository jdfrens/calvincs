require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/shared/_headerlesspage.html.erb" do

  user_fixtures

  it "should textilize the content when not logged in" do
    page = mock_model(Page, :content => "We state our mission.")
    assigns[:page] = page

    expect_textilize("We state our mission.")

    render "shared/_headerlesspage", :locals => { :page => page }

    response.should contain("We state our mission.")
    response.should_not have_selector("h1")
    response.should_not have_selector("a", :href=> edit_page_path(page))
  end

  # TODO: need to mock out user somehow to make this test easy 
  #  it "should textilize the content and offer edit link when logged in" do
  #    page = mock_model(Page, :content => "We state our mission.")
  #    assigns[:page] = page
  #
  #    expect_textilize("We state our mission.")
  #
  #    render "shared/_headerlesspage", :locals => { :page => page }
  #
  #    response.should contain("We state our mission.")
  #    response.should_not have_selector("h1")
  #    response.should have_selector("a", :href=> edit_page_path(page))
  #  end

end
