require 'spec_helper'

describe "/images/_image.html.erb" do

  before(:each) do
    @image = mock_model(Image,
            :url => "the url", :width => "295", :height => "295", :usability => "whatever",
            :caption => "the caption", :tags_string => "one two three")
    template.should_receive(:image).at_least(:once).and_return(@image)

    render "/images/_image"
  end

  it "should have url stuff" do
    response.should have_selector("a", :href => 'the url', :content => 'the url')
  end

  it "should have dimensions and usability" do
    response.should have_selector(".dimension", :content => "#{@image.width}x#{@image.height}")
    response.should have_selector(".usability", :content => "whatever")
  end

  it "should have a caption" do
    response.should have_selector(".caption", :content => @image.caption)
  end

  it "should have tags" do
    response.should have_selector(".tags", :content => "one two three")
  end

  it "should have an edit link" do
    response.should have_selector("a", :href => edit_image_path(@image), :content => "edit...")
  end

  it "should have a destroy link" do
    response.should have_selector("a", :content => "delete")
  end
end
