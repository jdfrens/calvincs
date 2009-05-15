require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/_image.html.erb" do

  before(:each) do
    @image = mock_model(Image,
            :url => "the url", :width => "42", :height => "666", :usability => "whatever",
            :caption => "the caption", :tags_string => "one two three")
    template.should_receive(:image).at_least(:once).and_return(@image)

    render "/images/_image"
  end

  it "should have a form" do
    assert_select "form[action=/images/#{@image.id}]"
  end

  it "should be an update" do
    response.should have_selector("input[name=_method][value=put]")  
  end

  it "should have url stuff" do
    assert_select "tr td input#image_url_#{@image.id}[value=#{@image.url}]"
    assert_select "tr td a[href=#{@image.url}]", "see picture"
  end

  it "should have dimensions and usability" do
    assert_select "tr td .dimension", "#{@image.width}x#{@image.height}"
    assert_select "tr td .usability", @image.usability.to_s
  end

  it "should have a caption" do
    assert_select "tr td", @image.caption
    assert_select "textarea#image_caption_#{@image.id}", @image.caption
  end

  it "should have tags" do
    assert_select "tr td input#image_tags_string_#{@image.id}[value=#{@image.tags_string}]"
  end

  it "should have a submit button" do
    assert_select "input[type=submit][value=Update]"
  end

  it "should have a spinner" do
    assert_spinner :number => @image.id
  end

  it "should have a destroy button" do
    assert_select "form[action=/images/#{@image.id}] input[type=submit][value=Destroy]"
    assert_select "input[name=_method][value=delete]"
  end

end