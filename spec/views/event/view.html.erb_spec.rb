require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/event/view.html.erb" do

  it "should view a complete event" do
    event = mock_model(Event,
      :title => "The Title", :subtitle => "The Subtitle",
      :presenter => "Dr. Presenter", :description => "The Description")
    assigns[:event] = event
    expect_textilize_wop("The Title")
    expect_textilize_wop("The Subtitle")
    expect_textilize_wop("Dr. Presenter")
    expect_textilize("The Description")

    render "event/view"

    assert_select "div#event-title" do
      assert_select "h1", "The Title"
      assert_select "h2#subtitle", "The Subtitle"
    end
    assert_select "div#event-presenter", "Dr. Presenter"
    assert_select "div#event-description", "The Description"
  end

  it "should view a minimal event" do
    event = mock_model(Event,
      :title => "The Title", :subtitle => nil,
      :presenter => nil, :description => "The Description")
    assigns[:event] = event
    expect_textilize_wop("The Title")
    expect_textilize("The Description")

    render "event/view"

    assert_select "div#event-title" do
      assert_select "h1", "The Title"
      assert_select "h2#subtitle", false
    end
    assert_select "div#event-presenter", false
    assert_select "div#event-description", "The Description"
  end
end
