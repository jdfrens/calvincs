require "#{File.dirname(__FILE__)}/../test_helper"

class CourseStoriesTest < ActionController::IntegrationTest

  fixtures :courses
  user_fixtures  

  def test_adding_a_new_course
    login 'calvin', 'calvinpassword'
  
    get "curriculum/new_course"
    assert_response :success
    assert_template "course_form"
    # user enters data
    
    post_via_redirect "curriculum/save_course",
        :course => {
	        :label => 'IS',
      	  :number => 101,
	        :title => 'Basics of IS',
      	  :credits => 5,
        }
    assert_response :success
    assert_template "list_courses"
    assert_select "ul#courses li", 4, 'there should be four courses now'
    assert_select "li:nth-child(3)", "IS 101: Basics of IS"
  end
  
  def test_view_a_course
    goto_course_listings
    assert_select "ul#courses li", 3, 'there should be three existing courses'
    assert_select "li:nth-child(1)", "CS 108: Introduction to Computing"
    
    get "curriculum/view_course/3"
    assert_response :success
    assert_template "course_detail"
  end

  #
  # Helpers
  #
  private
  
  def goto_course_listings
    get_via_redirect "curriculum/index"
    assert_response :success
    assert_template "list_courses"
  end
  
end
