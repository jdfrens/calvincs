require 'spec_helper'

describe "images/index.html.erb" do

  it "should have empty div with no images" do
    assign(:images, [])

    render

    rendered.should have_selector("div#image-list")
  end

  it "should have div with images" do
    images = [mock_model(Image), mock_model(Image), mock_model(Image)]
    assign(:images, images)

    view.should_receive(:render2).
      with(:partial => "image", :object => images[0]).and_return("image 0")
    view.should_receive(:render2).
      with(:partial => "image", :object => images[1]).and_return("image 1")
    view.should_receive(:render2).
      with(:partial => "image", :object => images[2]).and_return("image 2")
    view.should_receive(:render2).with("image_popups.js").
      and_return("popup JavaScript")

    render

    rendered.should have_selector("div#image-list") do |div|
      div.should contain("image 0")
      div.should contain("image 1")
      div.should contain("image 2")
    end
    rendered.should contain("popup JavaScript")
  end
end
