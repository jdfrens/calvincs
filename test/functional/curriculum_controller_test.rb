require File.dirname(__FILE__) + '/../test_helper'
require 'curriculum_controller'

# Re-raise errors caught by the controller.
class CurriculumController; def rescue_action(e) raise e end; end

class CurriculumControllerTest < Test::Unit::TestCase
  fixtures :courses, :users, :groups, :privileges, :groups_privileges
  
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
      assert_select "li:nth-child(1)", "CS 108: Introduction to Computing"
      assert_select "li:nth-child(2)", "CS 214: Programming Languages"
      assert_select "li:nth-child(3)", "IS 337: Website Administration"
    end
  end
  
  should "add a course when logged in" do
    get :new_course, {}, { 'current_user_id' => 1 }
    assert_response :success
    assert_standard_layout
    assert_template "curriculum/course_form"
    assert_select "h1", "Create Course"
    assert_course_form
  end
  
  should "redirect instead of adding course when NOT logged in" do
    get :new_course
    assert_redirected_to_login
  end
  
  should "view a course when NOT logged in" do
    get :view_course, :id => 3
    assert_response :success
    assert_standard_layout
    assert_template "curriculum/course_detail"
    assert_select "h1", "Course Details"
    assert_select "h2", "CS 108: Introduction to Computing"
    assert_select "p", "4 credits"
    assert_select "p", "The standard CS 1 class."
    assert_select "a[href=/curriculum/list_courses]"
  end
  
  should "redirect when id not specified when viewing details of course" do
    get :view_course, :id => nil
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
  end
  
  should "redirect when id is invalid when viewing details of course" do
    get :view_course, :id => 99
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
  end
  
  should "save a course when logged in" do
    post :save_course, { :course => {
      :label => 'IS', :number => '665',
      :title => 'One Off Devilry', :credits => '1'
    }}, { 'current_user_id' => 1 }
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
    course = Course.find_by_number(665)
    assert_not_nil course
    assert_equal 'One Off Devilry', course.title
  end
  
  should "redirect when trying to save a course and NOT logged in" do
    post :save_course, { :course => {
      :label => 'IS', :number => '665',
      :title => 'One Off Devilry', :credits => '1'
    }}
    assert_redirected_to_login
  end
  
  should "fail to save a bad course when logged in" do
    post :save_course, { :course => {
      :label => 'Q', :number => ''
    }}, { 'current_user_id' => 1 }
    assert_template "curriculum/course_form"
    assert_select "div#error", /errors prohibited this course from being saved/i
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
