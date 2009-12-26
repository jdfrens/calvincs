require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoursesController do
  user_fixtures
  fixtures :courses

  it "should show a list of courses" do
    get :index

    response.should be_success
    response.should render_template('courses/index')
  end

  context "building a new course" do
    it "should display a form" do
      get :new, {}, user_session(:edit)

      response.should be_success
      assigns[:course].should be_instance_of(Course)
      response.should render_template("courses/new")
    end

    it "should redirected when NOT logged in" do
      get :new

      response.should redirect_to(:controller => "users", :action => "login")
    end
  end

  context "saving a course" do
    it "should save a course" do
      post :save, { :course => {
              :department => 'IS', :number => '665',
              :title => 'One Off Devilry', :credits => '1'
      }}, user_session(:edit)

      response.should redirect_to(courses_path)
      flash.should be_empty

      course = Course.find_by_number(665)
      course.should_not be_nil
      course.title.should == 'One Off Devilry'
      
    end

    it "should redirect when not logged in" do
      post :save_course, { :course => {
              :department => 'IS', :number => '665',
              :title => 'One Off Devilry', :credits => '1'
      }}

      response.should redirect_to(:controller => "users", :action => "login")
    end

    it "should redirect when data is bad" do
      post :save, { :course => {
              :department => 'Q', :number => ''
      }}, user_session(:edit)

      response.should render_template("courses/new")
    end
  end

  context "showing a course" do
    it "should show a course" do
      get :show, :id => 3

      response.should be_success
      response.should render_template("courses/show")
    end

    it "should redirect when id is nil" do
      get :show, :id => nil
      response.should redirect_to(courses_path)
      flash.should be_empty
    end

    it "should redirect if course doesn't exist" do
      get :show, :id => "99"
      response.should redirect_to(courses_path)
      flash.should be_empty
    end
  end
end
