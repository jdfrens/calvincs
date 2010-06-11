require 'spec_helper'

describe ApplicationHelper do
  context "textilizing text" do
    it "should be an identity function" do
      helper.johnny_textilize("foo").should == "<p>foo</p>"
    end

    it "should do simple formatting" do
      helper.johnny_textilize("foo *bar*").should == "<p>foo <strong>bar</strong></p>"
    end

    it "should ignore hard breaks" do
      helper.johnny_textilize("foo\n bar").should == "<p>foo\n bar</p>"
    end

    it "should separate paragraphs" do
      helper.johnny_textilize("foo\n \n bar\n").should == "<p>foo</p>\nbar"
    end
  end
  
  context "lite textilizing text" do
    it "should be an identity function" do
      helper.johnny_textilize_lite("foo").should == "foo"
    end

    it "should do simple formatting" do
      helper.johnny_textilize_lite("foo *bar*").should == "foo <strong>bar</strong>"
    end

    it "should ignore hard breaks" do
      helper.johnny_textilize_lite("foo\n bar").should == "foo\n bar"
    end
  end

  context "creating a textilized link for a course" do
    it "should generate a link" do
      course = Factory.create(:course, :department => "CS", :number => "123",
                     :title => "The Title", :url => "http://www.example.com/cs123")

      helper.textilized_link(course).should ==
              "\"CS 123(CS 123: The Title)\":http://www.example.com/cs123"
    end

    it "should not generate a link when there's no URL" do
      course = Factory.create(:course, :department => "CS", :number => "123", :url => nil)

      helper.textilized_link(course).should == "CS 123"
    end
  end
  
  context "creating embedded links to courses" do
    it "should replace a short identifier" do
      course = Factory.create(:course, :department => "CS", :number => "123")

      helper.should_receive(:textilized_link).with(course).and_return("<CS 123 link>")

      helper.course_links("The cs123 course is awesome.").should ==
              "The <CS 123 link> course is awesome."
    end

    it "should replace multiple short identifiers" do
      course = Factory.create(:course, :department => "CS", :number => "123")

      helper.should_receive(:textilized_link).with(course).at_least(:once).and_return("<CS 123 link>")

      helper.course_links("The cs123 course is awesome.  Take cs123.").should ==
              "The <CS 123 link> course is awesome.  Take <CS 123 link>."
    end

    it "should replace multiple, different short identifiers" do
      course123 = Factory.create(:course, :department => "CS", :number => "123")
      course456 = Factory.create(:course, :department => "IS", :number => "456")

      helper.should_receive(:textilized_link).with(course123).at_least(:once).and_return("<CS 123 link>")
      helper.should_receive(:textilized_link).with(course456).at_least(:once).and_return("<IS 456 link>")

      helper.course_links("Take both cs123 and is456.").should == "Take both <CS 123 link> and <IS 456 link>."
    end
  end
end
