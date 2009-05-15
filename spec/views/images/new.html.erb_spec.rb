require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/new.html.erb" do

  it "should have a form" do
    assigns[:image] = mock_model(Image, :url => "the url", :caption => "the caption", :tags_string => "tags")
    
    render "/images/new"
    
    assert_select "form[action=/images][method=post]" do
      assert_select "input#image_url"
      assert_select "textarea#image_caption"
      assert_select "input#image_tags_string[value=tags]"
      assert_select "input[type=submit]"
    end
  end
end
