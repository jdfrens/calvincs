require 'spec_helper'

describe "personnel/show.html.erb" do
  before(:each) do
    view.should_receive(:render2).with('job_title').and_return("")
    view.should_receive(:render2).with('pages/image').and_return("")
    view.should_receive(:render2).with('contact_information').and_return("")
    view.should_receive(:render2).with('education').and_return("")
    view.should_receive(:render2).with('interests').and_return("")
    view.should_receive(:render2).with('profile').and_return("")
  end

  it "should render a bunch of partials" do
    user = mock_model(User, :full_name => "Full J. Name")
    assign(:user, user)

    view.should_receive(:current_user).and_return(nil)

    render

    rendered.should have_selector("h1", :content => "Full J. Name")
    rendered.should_not have_selector("a", :content => "edit...")
  end

  it "should render and edit link" do
    user = mock_model(User, :full_name => "Full J. Name")
    assign(:user, user)

    view.should_receive(:current_user).and_return(mock_model(User))

    render

    rendered.should have_selector("a", :content => "edit...")
  end
end
