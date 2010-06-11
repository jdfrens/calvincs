require 'spec_helper'

describe "/events/archive.html.erb" do

  it "should render years" do
    years = 1990..1992
    assigns[:years] = years

    render "events/archive"
    response.should have_selector("a", :href => "/events?year=1990", :content => "Events of 1990")
    response.should have_selector("a", :href => "/events?year=1991", :content => "Events of 1991")
    response.should have_selector("a", :href => "/events?year=1992", :content => "Events of 1992")
  end

end 

