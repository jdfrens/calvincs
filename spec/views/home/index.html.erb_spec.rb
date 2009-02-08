require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/home/index.html.erb" do

  it "should render the application layout with a title" do
    template.should_receive(:render).any_number_of_times.and_return("foobar")
    render "home/index"
  end

end

