require 'spec_helper'

describe "/newsitems/show.html.erb" do

  it "should show news item" do
    item = mock_model(Newsitem, :headline => "Some Headline", :content => "Something happened today.")
    assigns[:newsitem] = item

    template.should_receive(:current_user).and_return(false)

    render "newsitems/show"

    assert_select "h1", item.headline
    assert_select "div#news-item-content", "Something happened today."
  end

  it "should have edit link when logged in" do
    item = mock_model(Newsitem, :headline => "Some Headline", :content => "Something happened today.")
    assigns[:newsitem] = item
    
    template.should_receive(:current_user).and_return(true)

    render "newsitems/show"

    response.should have_selector("a", :href => "/newsitems/#{item.id}/edit", :content => "edit...")
  end
  
end
