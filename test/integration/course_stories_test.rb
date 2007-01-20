require "#{File.dirname(__FILE__)}/../test_helper"

class CourseStoriesTest < ActionController::IntegrationTest
  fixtures :courses
  
  should "be able to add a course" do
    get_via_redirect "curriculum/index"
    assert_response :success
    assert_template "list_courses"
    assert_select "ul#courses li", 3, 'there should be three existing courses'
    
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
  

end
