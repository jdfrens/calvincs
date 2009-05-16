require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/page/view.html.erb" do

  it "should handle a normal page" do
    page = mock_model(Page, :subpage? => false, :title => "Mission Statement", :content => "We state our mission.")
    assigns[:page] = page

    template.should_receive(:render).with(:partial => "image").and_return("IMAGE!")

    render "/page/view"

    assert_select "h1", "Mission Statement"
    response.should contain("IMAGE!")
    assert_select "div#page_content", /We state our mission./
  end

  it "should handle a subpage" do
    page = mock_model(Page, :subpage? => true, :content => "the content")
    assigns[:page] = page

    template.should_receive(:render).with(:partial => "image").and_return("IMAGE!")

    render "/page/view"

    assert_select "h1", "{{ A SUBPAGE HAS NO TITLE }}"
    response.should contain("IMAGE!")
    assert_select "div#page_content", /the content/
  end

end
