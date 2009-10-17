require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/_form.html.erb" do

  it "should view a form for a new event" do
    event = mock_model(Event, :new_record? => true, :kind => "Conference", :title => "the title",
                       :subtitle => "the subtitle",
                       :presenter => 'the presenter', :location => "somewhere",
                       :description => "description!",
                       :start => Time.now, :length => 1, :scale => "foobar scale")
    assigns[:event] = event

    render "events/_form"

    response.should have_selector("form", :action => "/events", :method => "post") do |form|
      form.should have_selector("#event_kind") do |type|
        type.should have_selector("option", :count => 2)
        type.should have_selector("option", :content => "Colloquium")
        type.should have_selector("option", :content => "Conference")
      end
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
    event = mock_model(Event, :new_record? => false, :kind => "Conference", :title => "the title",
                       :subtitle => "the subtitle",
                       :presenter => "presenter", :location => "somewhere",
                       :description => "description!",
                       :start => Time.now, :length => 1, :scale => "foobar scale")
    assigns[:event] = event

    render "events/_form"

    response.should have_selector("form", :action => "/events/#{event.id}") do |form|
      form.inner_html.should have_selector("input", :name => "_method", :value => "put")
    end
  end
end