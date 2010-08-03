require 'spec_helper'

describe "pages/show.html.erb" do

  it "should handle a normal page" do
    page = mock_model(Page, :subpage? => false, :title => "Mission Statement", :content => "We state our mission.")
    assign(:page, page)

    view.should_receive(:render2).with(:partial => "image").and_return("IMAGE!")
    view.should_receive(:current_user).and_return(nil)
    expect_textilize("We state our mission.")

    render

    assert_select "h1", "Mission Statement"
    rendered.should contain("IMAGE!")
    assert_select "div#page_content", /We state our mission./
    rendered.should_not have_selector("a", :href=> edit_page_path(page))
  end

  it "should handle a subpage" do
    page = mock_model(Page, :subpage? => true, :content => "the content")
    assign(:page, page)

    view.should_receive(:render2).with(:partial => "image").and_return("IMAGE!")
    view.should_receive(:current_user).and_return(nil)
    expect_textilize("the content")

    render

    assert_select "h1", "{{ A SUBPAGE HAS NO TITLE }}"
    rendered.should contain("IMAGE!")
    assert_select "div#page_content", /the content/
    rendered.should_not have_selector("a", :href=> edit_page_path(page))
  end

  it "should have edit link when logged in" do
    page = mock_model(Page, :subpage? => true, :content => "the content")
    assign(:page, page)

    view.should_receive(:render2).with(:partial => "image").and_return("IMAGE!")
    view.should_receive(:current_user).and_return(mock_model(User))

    render

    rendered.should have_selector("a", :href=> edit_page_path(page))
  end
end
