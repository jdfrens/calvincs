require 'spec_helper'

describe CoursesController do
  user_fixtures

  it "should show a list of courses" do
    cs_courses = mock("cs courses")
    is_courses = mock("is courses")
    interim_courses = mock("interim courses")

    Course.should_receive(:cs_courses).and_return(cs_courses)
    Course.should_receive(:is_courses).and_return(is_courses)
    Course.should_receive(:interim_courses).and_return(interim_courses)

    get :index

    response.should be_success
    response.should render_template('courses/index')
    assigns[:cs_courses].should == cs_courses
    assigns[:is_courses].should == is_courses
    assigns[:interim_courses].should == interim_courses
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

      response.should redirect_to(login_path)
    end
  end

  context "creating a course" do
    it "should create a course" do
      post :create, { :course => {
              :department => 'IS', :number => '665', :title => 'One Off Devilry'
      }}, user_session(:edit)

      response.should redirect_to(courses_path)
      flash.should be_empty

      course = Course.find_by_number(665)
      course.should_not be_nil
      course.title.should == 'One Off Devilry'
      
    end

    it "should redirect when not logged in" do
      post :create, { :course => {
              :department => 'IS', :number => '665',
              :title => 'One Off Devilry', :credits => '1'
      }}

      response.should redirect_to(login_path)
    end

    it "should redirect when data is bad" do
      post :create, { :course => {
              :department => 'Q', :number => ''
      }}, user_session(:edit)

      response.should render_template("courses/new")
    end
  end

  context "showing a course" do
    it "should NOT show a course" do
      course = mock_model(Course)

      get :show, :id => course.id

      response.should_not be_success
    end
  end

  context "editing a course" do
    it "should redirect if not logged in" do
      get :edit, :id => 3

      response.should redirect_to(login_path)
    end

    it "should look up the course and render" do
      course = mock_model(Course)

      Course.should_receive(:find).with(3).and_return(course)
      
      get :edit, { :id => 3 }, user_session(:edit)

      response.should be_success
      response.should render_template("courses/edit")
      assigns[:course].should == course
    end
  end

  context "updating a course" do
    it "should redirect when not logged in" do
      put :update, { :id => 666 }

      response.should redirect_to(login_path)
    end

    it "should do the update" do
      course = Factory.create(:course, :title => "to be changed")

      put :update, { :id => course.id, :course => { :title => "phooey" } }, user_session(:edit)

      response.should redirect_to(courses_path)
      course.reload
      course.title.should == "phooey"
    end

    it "should redo the edit if bad data" do
      course = Factory.create(:course, :number => "123")

      put :update, { :id => course.id, :course => { :number => "bad number" } }, user_session(:edit)

      response.should render_template("courses/edit")
      course.reload
      course.number.should == 123
    end
  end

  context "destroying a course" do
    it "should redirect if not logged in" do
      delete :destroy, { :id => 55 }

      response.should redirect_to(login_path)
    end

    it "should delete a course" do
      course = mock_model(Course)

      Course.should_receive(:destroy).with(course.id)

      delete :destroy, { :id => course.id }, user_session(:edit)

      response.should redirect_to(courses_path)
    end
  end
end
