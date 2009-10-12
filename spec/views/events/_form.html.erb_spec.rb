require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/_form.html.erb" do

  it "should view a form for a new event" do
    event = mock_model(Event, :new_record? => true, :kind => "Conference", :title => "the title",
                       :subtitle => "the subtitle",
                       :presenter => 'the presenter',
                       :description => "description!",
                       :start => Time.now, :length => 1)
    assigns[:event] = event

    render "events/_form"

    response.should have_selector("form", :action => "/events", :method => "post") do |form|
      form.inner_html.should have_selector("#event_kind") do |type|
        type.should have_selector("option", :count => 2)
        type.should have_selector("option", :content => "Colloquium")
        type.should have_selector("option", :content => "Conference")
      end
      form.inner_html.should have_selector "input#event_title"
      form.inner_html.should have_selector "input#event_subtitle"
      form.inner_html.should have_selector "input#event_presenter"
      form.inner_html.should have_selector "textarea#event_description"
      form.inner_html.should have_selector "input#event_length"
      form.inner_html.should have_selector "input[type=submit]"
    end
  end

  it "should view a form to edit an event" do
    event = mock_model(Event, :new_record? => false, :kind => "Conference", :title => "the title",
                       :subtitle => "the subtitle", :presenter => "presenter",
                       :description => "description!",
                       :start => Time.now, :length => 1)
    assigns[:event] = event

    render "events/_form"

    response.should have_selector("form", :action => "/events/#{event.id}") do |form|
      form.inner_html.should have_selector("input", :name => "_method", :value => "put")
    end
end
end