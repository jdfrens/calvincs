require 'spec_helper'

describe "pages/index.html.erb" do

  it "should have a table of pages" do
    normal_pages = [mock_model(Page), mock_model(Page), mock_model(Page)]
    subpages = [mock_model(Page), mock_model(Page), mock_model(Page)]
    assign(:normal_pages, normal_pages)
    assign(:subpages, subpages)

    view.should_receive(:render2).
            with(:partial => "page_entry", :collection => normal_pages).
            and_return("rendered normal pages")
    view.should_receive(:render2).
            with(:partial => "page_entry", :collection => subpages).
            and_return("rendered subpages")

    render

    rendered.should have_selector("a", :href => new_page_path)
    rendered.should have_selector("table", :summary => "normal pages")
    rendered.should contain("rendered normal pages")
    rendered.should have_selector("table", :summary => "subpages")
    rendered.should contain("rendered subpages")
  end

end
