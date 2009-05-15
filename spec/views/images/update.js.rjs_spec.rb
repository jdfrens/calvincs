require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/update.js.rjs" do

  it "should replace some html" do
    image = stub_model(Image)
    assigns[:image] = image

    template.should_receive(:render).with(:partial => "image", :object => image).and_return("stuff")
    
    render "/images/update.js"

    response.should have_rjs(:replace_html, "image-form-#{image.id}")
  end
  
end
