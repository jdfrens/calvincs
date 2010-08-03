require 'spec_helper'

describe "pages/_page_entry.html.erb" do

  it "should render a normal page" do
    page = mock_model(Page, :subpage? => false, :identifier => "hey", :title => "the nice title")

    view.should_receive(:page_entry).any_number_of_times.and_return(page)
    
    render

    rendered.should have_selector("td a", :href => edit_page_path(page), :content => "hey")
    rendered.should have_selector("td", :content => "hey")
    rendered.should have_selector("form", :action => page_path(page))
    rendered.should have_selector("input", :name => "_method", :value => "delete")
    rendered.should have_selector("input[value=Destroy]")
  end

  it "should render a subpage" do
    page = mock_model(Page, :subpage? => true, :identifier => "hey")

    view.should_receive(:page_entry).any_number_of_times.and_return(page)
    view.should_not_receive(:page_title).with(page)

    render

    rendered.should have_selector("td a", :href => edit_page_path(page), :content => "hey")
  end

end
