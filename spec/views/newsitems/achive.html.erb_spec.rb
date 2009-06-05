require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/newsitems/archive.html.erb" do

  it "should display years" do
    assigns[:years] = [1579, 1580, 1581]

    render "newsitems/archive"

    response.should have_selector("li a", :href => "/newsitems?year=1579", :content => "News of 1579")
    response.should have_selector("li a", :href => "/newsitems?year=1580", :content => "News of 1580")
    response.should have_selector("li a", :href => "/newsitems?year=1581", :content => "News of 1581")
  end

end