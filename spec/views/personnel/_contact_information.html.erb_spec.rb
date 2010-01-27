require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/_contact_information.html.erb" do
  it "should have data" do
    assigns[:user] = mock_model(User, :username => "jcalvin",
                                :email_address => "jcalvin@calvin.edu", :office_phone => '616.555.0666',
                                :office_location => "nowhere")
    assigns[:image] = mock_model(Image, :usability => :wide, :url => "/somewhere.gif", :caption => "the caption")

    render "/personnel/_contact_information"

    response.should have_selector("#contact-information") do |div|
      div.should have_selector("a", :href => "http://www.calvin.edu/~jcalvin/", :content => "home page")
      div.should have_selector("a", :href => "mailto:jcalvin@calvin.edu", :content => "jcalvin@calvin.edu")
      div.should have_selector("p", :content => "616.555.0666")
      div.should have_selector("p", :content => "nowhere")
    end
  end
end
