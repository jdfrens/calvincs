require 'spec_helper'

describe "/images/index.html.erb" do

  it "should have empty div with no images" do
    assigns[:images] = []

    render "/images/index"

    rendered.should have_selector("div#image-list")
  end

  it "should have div with images" do
    images = [mock_model(Image), mock_model(Image), mock_model(Image)]
    assigns[:images] = images

    view.should_receive(:render).with(:partial => "image", :object => images[0]).and_return("image 0")
    view.should_receive(:render).with(:partial => "image", :object => images[1]).and_return("image 1")
    view.should_receive(:render).with(:partial => "image", :object => images[2]).and_return("image 2")

    render "/images/index"

    rendered.should have_selector("div#image-list") do |div|
      div.should contain("image 0")
      div.should contain("image 1")
      div.should contain("image 2")
    end
  end

end
