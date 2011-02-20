require 'spec_helper'

describe "shared/_page.html.erb" do

  it "should display a header and defer to headlesspage template" do
    page = mock_model(Page, :title => "A Title")

    stub_template "shared/_subpage.html.erb" => 'headerless content'
    view.should_receive(:page).any_number_of_times.and_return(page)

    render

    rendered.should have_selector("h1", :content => "A Title")
    rendered.should contain("headerless content")
  end

end
