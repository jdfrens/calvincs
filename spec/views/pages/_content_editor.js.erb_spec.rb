require 'spec_helper'

describe "/pages/_content_editor.js.erb" do
  it "should render JavaScript" do
    assigns[:page] = page = mock_model(Page)

    render "pages/_content_editor.js"

    rendered.should contain("#edit_page_#{page.id}")
  end
end
