require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/_page_entry.html.erb" do

  it "should render a normal page" do
    page = mock_model(Page, :subpage? => false, :identifier => "hey", :title => "the nice title")

    render "/pages/_page_entry", :locals => { :page_entry => page }

    response.should have_selector("td a", :href => "/pages/#{page.id}/edit", :content => "the nice title")
    response.should have_selector("td", :content => "hey")
    response.should have_selector("form", :action => "/pages/#{page.id}")
    response.should have_selector("input", :name => "_method", :value => "delete")
    response.should have_selector("input[value=Destroy]")
  end

  it "should render a subpage" do
    page = mock_model(Page, :subpage? => true, :identifier => "hey")

    template.should_receive(:page_title).with(page).and_return("subpage title")

    render "/pages/_page_entry", :locals => { :page_entry => page }

    response.should have_selector("td a", :href => "/pages/#{page.id}/edit", :content => "subpage title")
  end

end
