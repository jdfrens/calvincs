require 'spec_helper'

describe "/home/_newsitem.html.erb" do

  it "should render a news item" do
    newsitem = mock_model(Newsitem, :teaser => "tease!")

    template.should_receive(:link_to_current_newsitem).
            with(newsitem, :text => "more...", :class => "more").
            and_return("link to news!")

    render "home/_newsitem", :locals => { :newsitem => newsitem }

    response.should contain("link to news!")
    response.should contain("tease!")
  end

end

