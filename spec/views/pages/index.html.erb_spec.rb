require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.erb" do

  it "should have a table of pages" do
    pages = [mock_model(Page), mock_model(Page), mock_model(Page)]
    assigns[:pages] = pages

    template.should_receive(:render).
            with(:partial => "page_entry", :collection => pages).
            and_return("rendered page entries")

    render "pages/index"

    response.should have_selector("h1", :content => "All Pages")
    response.should have_selector("table", :summary => "page list")
    response.should contain("rendered page entries")
    response.should have_selector("a", :href => new_page_path)
  end

end
