require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/view.html.erb" do

  describe "viewing a complete event" do

    before(:each) do
      event = mock(
              :title => "The Title", :subtitle => "The Subtitle",
                      :presenter => "Dr. Presenter", :description => "The Description")

      assigns[:event] = event
      expect_textilize_wop("The Title")
      expect_textilize_wop("The Subtitle")
      expect_textilize_wop("Dr. Presenter")
      expect_textilize("The Description")

      render "events/show"
    end

    it "should have a complete title" do
      response.should have_selector("div#title") do |div|
        div.should have_selector("h1", :content => "The Title")
        div.should have_selector(".subtitle", :content => "The Subtitle")
      end
    end

    it "should have a presenter" do
      assert_select "div#event-presenter", "Dr. Presenter"
    end

    it "should have a description" do
      assert_select "div#event-description", "The Description"
    end
  end

  describe "viewing a minimal event" do
    before(:each) do
      event = mock_model(Event,
              :title => "The Title", :subtitle => nil,
              :presenter => nil, :description => "The Description")
      assigns[:event] = event
      expect_textilize_wop("The Title")
      expect_textilize("The Description")

      render "events/show"
    end

    it "should have minimal title" do
      response.should have_selector("#title") do |title|
        title.should have_selector("h1", :content => "The Title")
      end
      response.should_not have_selector("#subtitle")
    end

    it "should not have presenter" do
      response.should_not have_selector("div#event-presenter")
    end

    it "should still have a description" do
      response.should have_selector("div#event-description", :content => "The Description")
    end
  end
 
end
