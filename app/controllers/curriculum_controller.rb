class CurriculumController < ApplicationController

  layout "standard"
  
  def index
    redirect_to :action => 'list_courses'
  end
  
  def list_courses
    @courses = Course.find(:all, :order => "label, number")
  end
  
  def new_course
    @title_verb = 'Enter'
    @course = nil
    render :template => 'curriculum/course_form'
  end
  
  def edit_course
    @title_verb = 'Edit'
    @course = Course.find(params[:id])
    render :template => 'curriculum/course_form'
  end
  
  def save_course
    @course = Course.new(params[:course])
    if @course.save
      redirect_to :action => 'list_courses'
    else
      @title_verb = 'Re-enter'
      flash[:error] = 'Invalid values for the course'
      render :template => 'curriculum/course_form'
    end
  end
  
end
