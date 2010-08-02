require 'spec_helper'

describe "/home/_event.html.erb" do

  it "should display an event" do
    event = mock_model(Event, :descriptor => "colloquium", :title => "The Title")

    view.should_receive(:event).at_least(:once).and_return(event)
    view.should_receive(:timing).and_return("tomorrow")

    render "home/_event"

    rendered.should have_selector("strong", :content => "Colloquium tomorrow!")
    rendered.should contain("The Title")
    rendered.should have_selector("a", :href => "/events#event-#{event.id}", :content => "more...")
  end
end
