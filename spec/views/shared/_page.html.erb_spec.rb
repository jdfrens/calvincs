require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/shared/_page.html.erb" do

  it "should display a header and defer to headlesspage template" do
    page = mock_model(Page, :title => "A Title")

    template.should_receive(:render).
            with(:partial => "shared/subpage", :locals => { :page => page }).
            and_return("headerless content")

    render "shared/_page", :locals => { :page => page }

    response.should have_selector("h1", :content => "A Title")
    response.should contain("headerless content")
  end
  
end
