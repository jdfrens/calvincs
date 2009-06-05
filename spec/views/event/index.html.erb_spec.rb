require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/event/index.html.erb" do

  describe "rendering an event" do

    before(:each) do
      timing = mock("timing", :to_s => "the timing")
      @event = mock_model(Event, :timing => timing)
      assigns[:events] = [@event]
      template.should_receive(:format_titles).with(@event).and_return("the titles!")

      render "event/index"
    end

    it "should have a header" do
      assert_select "h1", "Upcoming Events"
    end

    it "should have a title" do
      assert_select "div#event-#{@event.id}" do
        assert_select "h2", "the titles!"
      end
    end

    it "should have a time" do
      assert_select "div#event-#{@event.id}" do
        assert_select "p.when", "the timing"
      end
    end
  end
end 

