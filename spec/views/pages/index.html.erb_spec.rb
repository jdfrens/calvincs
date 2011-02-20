require 'spec_helper'

describe "pages/index.html.erb" do

  it "should have a table of pages" do
    normal_pages = [mock_model(Page, :stubbed_content => "rendered normal page")]
    subpages = [mock_model(Page, :stubbed_content => "rendered subpage")]
    assign(:normal_pages, normal_pages)
    assign(:subpages, subpages)

    stub_template "pages/_page_entry.html.erb" => "<%= page_entry.stubbed_content %>"

    render

    rendered.should have_selector("a", :href => new_page_path)
    rendered.should have_selector("table", :summary => "normal pages")
    rendered.should contain("rendered normal page")
    rendered.should have_selector("table", :summary => "subpages")
    rendered.should contain("rendered subpage")
  end

end
