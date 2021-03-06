require 'spec_helper'

describe "pages/_image.html.erb" do
  it "should handle a wide image" do
    assign(:image, mock_model(Image, :usability => :wide, :url => "/somewhere.gif", 
                                     :caption => "the caption"))

    render
    
    rendered.should have_selector(".img-right-wide") do |div|
      div.should have_selector("img#cool-pic", :src => "/somewhere.gif")
      div.should have_selector("p.img-caption", :content => "the caption")
    end
  end

  it "should handle a narrow image" do
    assign(:image, mock_model(Image, :usability => :narrow, :url => "/somewhere.gif", 
                                     :caption => "the caption"))

    render

    rendered.should have_selector(".img-right-narrow")
  end

  it "should handle a square image" do
    assign(:image, mock_model(Image, :usability => :square, :url => "/somewhere.gif", 
                                     :caption => "the caption"))

    render

    rendered.should have_selector(".img-right-square")
  end

  it "should handle no image" do
    assign(:image, nil)

    render

    rendered.should_not have_selector("img")
    rendered.should_not have_selector(".img-caption")
  end
end
