require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/event/list.html.erb" do

  it "should render list" do
    start = mock("start time")
    event = mock_model(Event,
      :title => "Colloquium of Today", :subtitle => "Talk about Today!",
      :start => start
    )
    assigns[:events] = [event]
    start.should_receive(:to_s).with(:colloquium).and_return("starting time")
    expect_textilize_wop("Colloquium of Today")
    expect_textilize_wop("Talk about Today!")
    
    render "event/list"

    assert_select "h1", "Upcoming Events"
    assert_select "div#event-#{event.id}" do
      assert_select "h2", "Colloquium of Today: Talk about Today!" do
        assert_select ".title", "Colloquium of Today"
        assert_select "br", true
        assert_select ".subtitle", "Talk about Today!"
      end
      assert_select "p.when", "starting time"
    end
  end

  it "should display data for an event without optional fields" do
    start = mock("start time")
    event = mock_model(Event,
      :title => "Future Conference", :subtitle => nil,
      :start => start
    )
    assigns[:events] = [event]
    start.should_receive(:to_s).with(:colloquium).and_return("starting time")
    expect_textilize_wop("Future Conference")
    
    render 'event/list'

    assert_response :success
    assert_select "div#event-#{event.id}" do
      assert_select "h2", "Future Conference" do
        assert_select ".title", "Future Conference"
        assert_select "br", false
        assert_select ".subtitle", false
      end
      assert_select "p.when", "starting time"
    end
  end

end

