require 'spec_helper'

describe "pages/_content_editor.js.erb" do
  it "should render JavaScript" do
    page =  mock_model(Page)
    assign(:page, page)

    render

    rendered.should contain("#edit_page_#{page.id}")
  end
end
