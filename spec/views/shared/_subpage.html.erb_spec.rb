require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/shared/_subpage.html.erb" do

  it "should textilize the content when not logged in" do
    page = mock_model(Page, :content => "We state our mission.")

    expect_textilize("We state our mission.")

    render "shared/_subpage", :locals => { :page => page }

    response.should contain("We state our mission.")
    response.should_not have_selector("h1")
    response.should_not have_selector("a", :href=> edit_page_path(page))
  end

  # TODO: need to mock out user somehow to make this test easy 
  #  it "should textilize the content and offer edit link when logged in" do
  #    page = mock_model(Page, :content => "We state our mission.")
  #
  #    expect_textilize("We state our mission.")
  #
  #    render "shared/_subpage", :locals => { :page => page }
  #
  #    response.should contain("We state our mission.")
  #    response.should_not have_selector("h1")
  #    response.should have_selector("a", :href=> edit_page_path(page))
  #  end

end
