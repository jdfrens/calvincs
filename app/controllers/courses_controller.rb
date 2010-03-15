class CoursesController < ApplicationController

  restrict_to :edit, :except => [:index, :show]

  def index
    @cs_courses = Course.cs_courses
    @is_courses = Course.is_courses
    @interim_courses = Course.interim_courses
  end

  def show
    @course = Course.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => 'index'
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid values for the course'
      render :template => 'courses/new'
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    course = Course.find(params[:id])
    course.update_attributes(params[:course])
    if course.save
      redirect_to courses_path
    else
      render :edit
    end
  end

  def destroy
    Course.destroy(params[:id])
    redirect_to courses_path
  end  
end
