require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoursesController do
  integrate_views

  user_fixtures
  fixtures :courses

  it "should show a list of courses" do
    get :index

    assert_response :success
    assert_template 'courses/index'
    assert_select "h1", "Course Listing"
    assert_select "ul#courses" do
      assert_select "li:nth-child(1)", "CS 108: Introduction to Computing"
      assert_select "li:nth-child(2)", "CS 214: Programming Languages"
      assert_select "li:nth-child(3)", "IS 337: Website Administration"
    end
  end
  
  def test_new_course
    get :new, {}, user_session(:edit)

    response.should be_success
    assigns[:course].should be_instance_of(Course)
    assert_template "courses/new"
  end
  
  it "should redirected when NOT logged in" do
    get :new_course

    response.should redirect_to(:controller => "users", :action => "login")
  end
  
  it "should show a course" do
    get :view_course, :id => 3

    assert_response :success
    assert_template "courses/course_detail"
    assert_select "h1", "Course Details"
    assert_select "h2", "CS 108: Introduction to Computing"
    assert_select "p", "4 credits"
    assert_select "p", "The standard CS 1 class."
    assert_select "a[href=/courses]"
  end
  
  def test_view_course_redirectes_when_id_is_nil
    get :view_course, :id => nil
    assert_redirected_to :action => 'index'
    assert flash.empty?
  end
  
  def test_view_course_redirectes_when_id_is_invalid
    get :view_course, :id => 99
    assert_redirected_to :action => 'index'
    assert flash.empty?
  end
  
  def test_save_course
    post :save, { :course => {
        :department => 'IS', :number => '665',
        :title => 'One Off Devilry', :credits => '1'
      }}, user_session(:edit)
    assert_redirected_to :action => 'index'
    assert flash.empty?
    course = Course.find_by_number(665)
    assert_not_nil course
    assert_equal 'One Off Devilry', course.title
  end
  
  it "should redirect save/course to login" do
    post :save_course, { :course => {
        :department => 'IS', :number => '665',
        :title => 'One Off Devilry', :credits => '1'
      }}
    
    response.should redirect_to(:controller => "users", :action => "login")
  end
  
  def test_save_course_fails_with_bad_data
    post :save, { :course => {
        :department => 'Q', :number => ''
      }}, user_session(:edit)
    assert_template "courses/new"
  end
  
end
