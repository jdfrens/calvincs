require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/index.html.erb" do

  describe "rendering an event" do
    before(:each) do
      timing = mock("timing", :to_s => "the timing")
      @event = mock_model(Event, :timing => timing, :presenter => "Charles M. Ruby")
      assigns[:events] = [@event]
      assigns[:title] = "The Title"
      template.should_receive(:format_titles).with(@event).and_return("the titles!")
      template.stub!(:current_user).and_return(false)

      render "events/index"
    end

    it "should have a header" do
      assert_select "h1", "The Title"
    end

    it "should have a title" do
      assert_select "div#event-#{@event.id}" do
        assert_select "h2", /the titles!/
      end
    end

    it "should have a presenter" do
      response.should have_selector(".presenter", :content => "Charles M. Ruby")
    end

    it "should have a time" do
      assert_select "div#event-#{@event.id}" do
        assert_select ".when", "the timing"
      end
    end

    it "should have a more link" do
      response.should have_selector("a", :href => "/events/#{@event.id}", :content => "more...")
    end
  end

end 

