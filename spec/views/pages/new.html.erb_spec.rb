require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/new.html.erb" do

  it "should display errors" do
    page = mock_model(Page, :new_record? => false, :valid? => false, :identifier => "some_identifier", :title => "some title", :content => "some content")
    assigns[:page] = page
    
    template.should_receive(:error_messages_for).with(:page).and_return("errors!")

    render "/pages/new"

    response.should have_selector("#error") do |div|
      div.should contain("errors!")
    end
  end

  it "should not display errors for a new record" do
    page = mock_model(Page, :new_record? => true, :valid? => false, :identifier => "some_identifier", :title => "some title", :content => "some content")
    assigns[:page] = page

    template.should_not_receive(:error_messages_for)

    render "/pages/new"

    response.should_not have_selector("#error")
  end

end

