require 'spec_helper'

describe "personnel/_degree.html.erb" do
  it "should render degree with link" do
    degree = mock_model(Degree, :degree_type => "B.A.", :year => 1492,
                        :institution => "College University", :url => "http://cu.edu/")
    
    view.should_receive(:degree).any_number_of_times.and_return(degree)
    
    render
    
    rendered.should have_selector("li") do |li|
      li.should contain("B.A., College University, 1492")
      li.should have_selector("a", :href => "http://cu.edu/", 
                              :content => "College University")
    end
  end

  it "should render degree without link" do
    degree = mock_model(Degree, :degree_type => "B.A.", :year => 1492,
                        :institution => "College University", :url => "")
    
    view.should_receive(:degree).any_number_of_times.and_return(degree)
    
    render
    
    rendered.should have_selector("li") do |li|
      li.should contain("B.A., College University, 1492")
      li.should_not have_selector("a")
    end
  end
end
