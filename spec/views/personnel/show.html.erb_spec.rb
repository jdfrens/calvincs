require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/show.html.erb" do
  it "should render a bunch of partials" do
    assigns[:user] = user = mock_model(User, :full_name => "Full J. Name")

    template.should_receive(:current_user).and_return(nil)
    expect_partial_renders

    render "personnel/show"

    response.should have_selector("h1", :content => "Full J. Name")
    response.should_not have_selector("a", :content => "edit...")
  end

  it "should render and edit link" do
    assigns[:user] = user = mock_model(User, :full_name => "Full J. Name")

    template.should_receive(:current_user).and_return(mock_model(User))
    expect_partial_renders

    render "personnel/show"

    response.should have_selector("a", :content => "edit...")
  end

  def expect_partial_renders
    template.should_receive(:render).with('job_title').and_return("")
    template.should_receive(:render).with('pages/image').and_return("")
    template.should_receive(:render).with('contact_information').and_return("")
    template.should_receive(:render).with('education').and_return("")
    template.should_receive(:render).with('interests').and_return("")
    template.should_receive(:render).with('profile').and_return("")
  end
end
