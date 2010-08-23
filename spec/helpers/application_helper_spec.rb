require 'spec_helper'

describe ApplicationHelper do
  context "textilizing text" do
    it "should be an identity function" do
      helper.johnny_textilize("foo").should == "<p>foo</p>"
    end

    it "should be html safe" do
      helper.johnny_textilize("foo").should be_html_safe
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

    it "should be an identity function" do
      helper.johnny_textilize_lite("foo").should be_html_safe
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

      helper.should_receive(:textilized_link).with(course).
        at_least(:once).and_return("<CS 123 link>")

      helper.course_links("The cs123 course is awesome.  Take cs123.").should ==
              "The <CS 123 link> course is awesome.  Take <CS 123 link>."
    end

    it "should replace multiple, different short identifiers" do
      course123 = Factory.create(:course, :department => "CS", :number => "123")
      course456 = Factory.create(:course, :department => "IS", :number => "456")

      helper.should_receive(:textilized_link).with(course123).
        at_least(:once).and_return("<CS 123 link>")
      helper.should_receive(:textilized_link).with(course456).
        at_least(:once).and_return("<IS 456 link>")

      helper.course_links("Take both cs123 and is456.").should == "Take both <CS 123 link> and <IS 456 link>."
    end
  end
  
  context "menu items" do
    before(:each) do
      helper.stub(:current_page?).with("the url").any_number_of_times.and_return(false)
    end
    
    it "should generate a link" do
      helper.menu_item("text", "the url").should have_selector("li") do |li|
        li.should have_selector("a", :href => "the url")
      end
    end
    
    it "should not generate a current link" do
      helper.should_receive(:current_page?).with("the url").at_least(:once).and_return(false)
      
      helper.menu_item("text", "the url").should_not have_selector("li", :class => "current")
    end
    
    it "should generate a current link" do
      helper.should_receive(:current_page?).with("the url").at_least(:once).and_return(true)
      
      helper.menu_item("text", "the url").should have_selector("li", :class => "current")
    end
    
    it "should generate a current link from extra parameter" do
      helper.menu_item("text", "the url", :current => true).should have_selector("li", :class => "current")
    end
    
    it "should not generate submenu" do
      helper.should_not_receive(:with_output_buffer)

      helper.menu_item("text", "the url") do
        "some content"
      end.should_not contain("some content")
    end
    
    it "should generate submenu" do
      helper.should_receive(:with_output_buffer).and_return("some content")
      
      helper.menu_item("text", "the url", :current => true) do
        "some content"
      end.should contain("some content")
    end
  end
  
  context "when should the events submenu be used?" do
    it "should not normally display" do
      helper.events_submenu?.should == false
    end
    
    it "should display when the events controller is active" do
      helper.should_receive("params").and_return({ :controller => "events"})
      
      helper.events_submenu?.should == true
    end
  end
  
  context "event paths" do
    it "should redirect colloquium path to event" do
      event = mock_model(Colloquium)
      
      helper.colloquium_path(event).should == event_path(event)
    end

    it "should redirect conference path to event" do
      event = mock_model(Conference)
      
      helper.conference_path(event).should == event_path(event)
    end

    it "should redirect colloquium url to event" do
      event = mock_model(Colloquium)
      
      helper.colloquium_url(event).should == event_url(event)
    end

    it "should redirect conference url to event" do
      event = mock_model(Conference)
      
      helper.conference_url(event).should == event_url(event)
    end

    it "should redirect colloquia path to events" do
      helper.colloquia_path.should == events_path
    end

    it "should redirect conferences path to events" do
      helper.conferences_path.should == events_path
    end
  end
end
