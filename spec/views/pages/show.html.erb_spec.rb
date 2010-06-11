require 'spec_helper'

describe "/pages/view.html.erb" do

  it "should handle a normal page" do
    page = mock_model(Page, :subpage? => false, :title => "Mission Statement", :content => "We state our mission.")
    assigns[:page] = page

    template.should_receive(:render).with(:partial => "image").and_return("IMAGE!")
    template.should_receive(:current_user).and_return(nil)
    expect_textilize("We state our mission.")

    render "/pages/show"

    assert_select "h1", "Mission Statement"
    response.should contain("IMAGE!")
    assert_select "div#page_content", /We state our mission./
    response.should_not have_selector("a", :href=> edit_page_path(page))
  end

  it "should handle a subpage" do
    page = mock_model(Page, :subpage? => true, :content => "the content")
    assigns[:page] = page

    template.should_receive(:render).with(:partial => "image").and_return("IMAGE!")
    template.should_receive(:current_user).and_return(nil)
    expect_textilize("the content")

    render "/pages/show"

    assert_select "h1", "{{ A SUBPAGE HAS NO TITLE }}"
    response.should contain("IMAGE!")
    assert_select "div#page_content", /the content/
    response.should_not have_selector("a", :href=> edit_page_path(page))
  end

  it "should have edit link when logged in" do
    page = mock_model(Page, :subpage? => true, :content => "the content")
    assigns[:page] = page

    template.should_receive(:render).with(:partial => "image").and_return("IMAGE!")
    template.should_receive(:current_user).and_return(mock_model(User))

    render "/pages/show"

    response.should have_selector("a", :href=> edit_page_path(page))
  end

end
