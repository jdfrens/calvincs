require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/event/new.html.erb" do

  it "should view a form for a new event" do
    render 'event/new'

    assert_select "h1", "New Event"
    assert_select "form[action=/event/create]" do
      assert_select "select#event_type" do
        assert_select "option", 2
        assert_select "option", /colloquium/i
        assert_select "option", /conference/i
      end
      assert_select "input#event_title"
      assert_select "input#event_subtitle"
      assert_select "textarea#event_description"
      assert_datetime_selector "event", "start"
      assert_select "input#event_length"
      assert_select "input[type=submit]"
    end
  end

end
