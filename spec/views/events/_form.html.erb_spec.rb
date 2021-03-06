require 'spec_helper'

describe "events/_form.html.erb" do

  it "should view a form for a new colloquium" do
    event = mock_model(Event, :kind => "Colloquium", :descriptor => "colloquium",
                       :title => "the title", :subtitle => "the subtitle",
                       :presenter => 'the presenter', :location => "somewhere",
                       :description => "description!",
                       :start => Time.now, :length => 1, :scale => "days").as_new_record
    assign(:event, event)

    render

    rendered.should have_selector("form", :action => "/events") do |form|
      form.should have_selector("input", :type => "hidden", :name => "event[kind]", 
                                         :value => "Colloquium")
      form.should have_selector "input#event_descriptor"
      form.should have_selector "input#event_title"
      form.should have_selector "input#event_subtitle"
      form.should have_selector "input#event_presenter"
      form.should have_selector "input#event_location"
      form.should have_selector "textarea#event_description"
      form.should have_selector "input#event_length"
      form.should have_selector("#scale", :content => "days")
      form.should have_selector "input[type=submit]"
    end
  end

  it "should view a form for a new conference" do
    event = mock_model(Event, :kind => "Conference", :descriptor => "conference",
                       :title => "the title", :subtitle => "the subtitle",
                       :presenter => 'the presenter', :location => "somewhere",
                       :description => "description!",
                       :start => Time.now, :length => 1, :scale => "foobar scale").as_new_record
    assign(:event, event)

    render

    rendered.should have_selector("form", :action => "/events") do |form|
      form.should have_selector("input", :type => "hidden", :name => "event[kind]", 
                                         :value => "Conference")
      form.should have_selector "input#event_descriptor"
      form.should have_selector "input#event_title"
      form.should have_selector "input#event_subtitle"
      form.should have_selector "input#event_presenter"
      form.should have_selector "input#event_location"
      form.should have_selector "textarea#event_description"
      form.should have_selector "input#event_length"
      form.should have_selector("#scale", :content => "foobar scale")
      form.should have_selector "input[type=submit]"
    end
  end

  it "should view a form to edit an event" do
    event = mock_model(Event, :new_record? => false, :kind => "Conference", :descriptor => "conference",
                       :title => "the title", :subtitle => "the subtitle",
                       :presenter => "presenter", :location => "somewhere",
                       :description => "description!",
                       :start => Time.now, :length => 1, :scale => "foobar scale")
    assign(:event, event)

    render

    rendered.should have_selector("form", :action => "/events/#{event.id}") do |form|
      form.inner_html.should have_selector("input", :name => "_method", :value => "put")
    end
  end
end
