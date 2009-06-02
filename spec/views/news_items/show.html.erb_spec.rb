require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news_items/show.html.erb" do

  it "should show news item" do
    item = mock_model(NewsItem, :headline => "Some Headline", :content => "Something happened today.")
    assigns[:news_item] = item

    render "news_items/show"

    assert_select "h1", item.headline
    assert_select "div#news-item-content", "Something happened today."
  end

  it "should have edit link when logged in" do
    item = mock_model(NewsItem, :headline => "Some Headline", :content => "Something happened today.")
    assigns[:news_item] = item
    
    template.should_receive(:current_user).and_return(true)

    render "news_items/show"

    response.should have_selector("a", :href => "/news_items/edit/#{item.id}", :content => "edit...")
  end
  
end