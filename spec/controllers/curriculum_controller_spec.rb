require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurriculumController do
  integrate_views

  fixtures :courses, :users, :groups, :privileges, :groups_privileges
  
  def test_index_redirects_to_course_listing
    get :index
    assert_redirected_to :action => 'list_courses'
  end
  
  def test_list_courses
    get :list_courses

    assert_response :success
    assert_template 'curriculum/list_courses'
    assert_select "h1", "Course Listing"
    assert_select "ul#courses" do
      assert_select "li:nth-child(1)", "CS 108: Introduction to Computing"
      assert_select "li:nth-child(2)", "CS 214: Programming Languages"
      assert_select "li:nth-child(3)", "IS 337: Website Administration"
    end
  end
  
  def test_new_course
    get :new_course, {}, user_session(:edit)

    assert_response :success
    assert_template "curriculum/course_form"
    assert_select "h1", "Create Course"
    assert_course_form
  end
  
  it "should redirected when NOT logged in" do
    get :new_course

    response.should redirect_to(:controller => "users", :action => "login")
  end
  
  it "should redirect course/view" do
    get :view_course, :id => 3

    assert_response :success
    assert_template "curriculum/course_detail"
    assert_select "h1", "Course Details"
    assert_select "h2", "CS 108: Introduction to Computing"
    assert_select "p", "4 credits"
    assert_select "p", "The standard CS 1 class."
    assert_select "a[href=/curriculum/list_courses]"
  end
  
  def test_view_course_redirectes_when_id_is_nil
    get :view_course, :id => nil
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
  end
  
  def test_view_course_redirectes_when_id_is_invalid
    get :view_course, :id => 99
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
  end
  
  def test_save_course
    post :save_course, { :course => {
        :label => 'IS', :number => '665',
        :title => 'One Off Devilry', :credits => '1'
      }}, user_session(:edit)
    assert_redirected_to :action => 'list_courses'
    assert flash.empty?
    course = Course.find_by_number(665)
    assert_not_nil course
    assert_equal 'One Off Devilry', course.title
  end
  
  it "should redirect save/course to login" do
    post :save_course, { :course => {
        :label => 'IS', :number => '665',
        :title => 'One Off Devilry', :credits => '1'
      }}
    
    response.should redirect_to(:controller => "users", :action => "login")
  end
  
  def test_save_course_fails_with_bad_data
    post :save_course, { :course => {
        :label => 'Q', :number => ''
      }}, user_session(:edit)
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
