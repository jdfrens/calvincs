require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoursesHelper do

  context "linking to online course material" do
    it "should return the full title by default" do
      course = mock_model(Course, :full_title => "The Full Course", :url => "")

      helper.link_to_online_materials(course).should == "The Full Course"
    end

    it "should return a link when there is a url" do
      course = mock_model(Course, :identifier => "CS 108", :title => "Intro to Computing",
                          :url => "http://www.example.com/cs108")

      helper.link_to_online_materials(course).should ==
              "<a href=\"http://www.example.com/cs108\">CS 108</a>: Intro to Computing"
    end
  end
end
