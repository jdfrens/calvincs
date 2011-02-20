require 'spec_helper'

describe "images/index.html.erb" do

  it "should have empty div with no images" do
    assign(:images, [])

    render

    rendered.should have_selector("div#image-list")
  end

  it "should have div with images" do
    images = [
      mock_model(Image, :stubbed_content => "image 0"),
      mock_model(Image, :stubbed_content => "image 1"),
      mock_model(Image, :stubbed_content => "image 2")]
    assign(:images, images)

    stub_template "images/_image.html.erb" => "<%= image.stubbed_content %>"
    stub_template "images/_image_popups.js" => "popup JavaScript"

    render

    rendered.should have_selector("div#image-list") do |div|
      div.should contain("image 0")
      div.should contain("image 1")
      div.should contain("image 2")
    end
    rendered.should contain("popup JavaScript")
  end
end
