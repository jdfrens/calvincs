require 'spec_helper'

describe "/home/_event.html.erb" do

  it "should display an event" do
    event = mock_model(Event, :descriptor => "colloquium", :title => "The Title")

    template.should_receive(:event).at_least(:once).and_return(event)
    template.should_receive(:timing).and_return("tomorrow")

    render "home/_event"

    response.should have_selector("strong", :content => "Colloquium tomorrow!")
    response.should contain("The Title")
    response.should have_selector("a", :href => "/events#event-#{event.id}", :content => "more...")
  end
end
