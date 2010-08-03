require 'spec_helper'

describe "newsitems/show.html.erb" do

  it "should show news item" do
    item = mock_model(Newsitem, :headline => "Some Headline", :content => "Something happened today.")
    assign(:newsitem, item)

    view.should_receive(:current_user).and_return(false)
    expect_textilize("Something happened today.")

    render

    assert_select "h1", item.headline
    assert_select "div#news-item-content", "Something happened today."
  end

  it "should have edit link when logged in" do
    item = mock_model(Newsitem, :headline => "Some Headline", :content => "Something happened today.")
    assign(:newsitem, item)
    
    view.should_receive(:current_user).and_return(true)
    expect_textilize("Something happened today.")

    render

    rendered.should have_selector("a", :href => "/newsitems/#{item.id}/edit", :content => "edit...")
  end
  
end
