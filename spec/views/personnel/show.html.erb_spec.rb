require 'spec_helper'

describe "personnel/show.html.erb" do
  before(:each) do
    stub_template 'personnel/_job_title.html.erb' => ''
    stub_template 'pages/_image.html.erb' => ''
    stub_template 'personnel/_contact_information.html.erb' => ''
    stub_template 'personnel/_education.html.erb' => ''
    stub_template 'personnel/_interests.html.erb' => ''
    stub_template 'personnel/_profile.html.erb' => ''
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
