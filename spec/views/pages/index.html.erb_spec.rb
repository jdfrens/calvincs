require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.erb" do

  it "should have a table of pages" do
    normal_pages = [mock_model(Page), mock_model(Page), mock_model(Page)]
    subpages = [mock_model(Page), mock_model(Page), mock_model(Page)]
    assigns[:normal_pages] = normal_pages
    assigns[:subpages] = subpages

    template.should_receive(:render).
            with(:partial => "page_entry", :collection => normal_pages).
            and_return("rendered normal pages")
    template.should_receive(:render).
            with(:partial => "page_entry", :collection => subpages).
            and_return("rendered subpages")

    render "pages/index"

    response.should have_selector("a", :href => new_page_path)
    response.should have_selector("table", :summary => "normal pages")
    response.should contain("rendered normal pages")
    response.should have_selector("table", :summary => "subpages")
    response.should contain("rendered subpages")
  end

end
