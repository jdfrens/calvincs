require 'spec_helper'

describe "home/_newsitem.html.erb" do

  it "should render a news item" do
    newsitem = mock_model(Newsitem, :teaser => "tease!")

    view.should_receive(:newsitem).any_number_of_times.and_return(newsitem)
    view.should_receive(:link_to_current_newsitem).
            with(newsitem, :text => "more...", :class => "more").
            and_return("link to news!")

    render

    rendered.should contain("link to news!")
    rendered.should contain("tease!")
  end

end

