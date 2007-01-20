require File.dirname(__FILE__) + '/../test_helper'
require 'curriculum_controller'

# Re-raise errors caught by the controller.
class CurriculumController; def rescue_action(e) raise e end; end

class CurriculumControllerTest < Test::Unit::TestCase
  fixtures :courses
  
  def setup
    @controller = CurriculumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "redirect to course listing for index action" do
    get :index
    assert_redirected_to :action => 'list_courses'
  end
  
  should "get list of all courses" do
    get :list_courses
    assert_response :success
    assert_standard_layout
    assert_template 'curriculum/list_courses'
    assert_select "h1", "Course Listing"
    assert_select "ul#courses" do
      assert_select "li:nth-child(1)", "CS 108: Introduction to Programming"
      assert_select "li:nth-child(2)", "CS 214: Programming Languages"
      assert_select "li:nth-child(3)", "IS 337: Website Administration"
    end
  end
  
  should "add a course" do
    get :new_course
    assert_response :success
    assert_standard_layout
    assert_template "curriculum/course_form"
    assert_select "h1", "Enter Course Data"
    assert_course_form
  end
  
  should "edit a course" do
    get :edit_course, :id => 3
    assert_response :success
    assert_standard_layout
    assert_template "curriculum/course_form"
    assert_select "h1", "Edit Course Data"
    assert_course_form :label => 'CS', :number => '108', :title => 'Introduction to Programming', :credits => '4', :description => 'The standard CS 1 class.'
  end
  
  
  should "save a course" do
    post :save_course, :course => {
      :label => 'IS', :number => '665',
      :title => 'One Off Devilry', :credits => '1'
    }
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
    course = Course.find_by_number(665)
    assert_not_nil course
    assert_equal 'One Off Devilry', course.title
  end
  
  should "fail to save a bad course" do
    post :save_course, :course => {
      :label => 'Q', :number => ''
    }
    assert_template "curriculum/course_form"
    assert_select "div#error", /errors prohibited this course from being saved/
    assert !flash.empty?
    assert_equal 'Invalid values for the course', flash[:error]
  end

  #
  # Helpers
  #
  private

  def assert_course_form(options={})
    assert_select "form[action=/curriculum/save_course][method=post]" do
      assert_select "table" do
	assert_select "tr" do
	  if (options[:label])
  	    assert_select "td input#course_label[type=text][value=#{options[:label]}]"
	  else
  	    assert_select "td input#course_label[type=text]"
	  end
	end
	assert_select "tr" do
	  if (options[:number])
 	    assert_select "td input#course_number[type=text][value=#{options[:number]}]"
	  else
 	    assert_select "td input#course_number[type=text]"
	  end
	end
	assert_select "tr" do
	  if (options[:title])
	    assert_select "td input#course_title[type=text][value=#{options[:title]}]"
	  else
	    assert_select "td input#course_title[type=text]"
	  end
	end
	assert_select "tr" do
	  if (options[:credits])
	    assert_select "td input#course_credits[type=text][value=#{options[:credits]}]"
	  else
	    assert_select "td input#course_credits[type=text]"
	  end
	end
	assert_select "tr" do
	  if (options[:description])
	    assert_select "td textarea#course_description", options[:description]
	  else
	    assert_select "td textarea#course_description"
	  end
	end
	assert_select "tr" do
	  assert_select "td input[type=submit]"
	end
      end
    end
  end

end
