class CoursesController < ApplicationController
  
  restrict_to :edit, :except => [
      :index, :view_course
  ]
  
  def index
    @courses = Course.find(:all, :order => "department, number")
  end
  
  def view_course
    begin
      @course = Course.find(params[:id])
      render :template => 'courses/course_detail'
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => 'index'
    end
  end
  
  def new
    @course = Course.new
  end

  def save_course
    @course = Course.new(params[:course])
    if @course.save
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid values for the course'
      render :template => 'courses/new'
    end
  end
  
end
