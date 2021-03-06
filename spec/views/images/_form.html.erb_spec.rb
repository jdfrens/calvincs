require 'spec_helper'

describe "images/_form.html.erb" do
  it "should build a form" do
    assign(:image, mock_model(Image, :url => "the url", :caption => "the caption", 
                                     :tags_string => "tags"))

    render

    assert_select "form" do
      assert_select "input#image_url"
      assert_select "textarea#image_caption"
      assert_select "input#image_tags_string[value=tags]"
      assert_select "input[type=submit]"
    end
  end

end
