class CurriculumController < ApplicationController

  layout "standard"
  
  def index
    redirect_to :action => 'list_courses'
  end
  
  def list_courses
    @courses = Course.find(:all, :order => "label, number")
  end
  
  def new_course
    
  end
  
  def save_course
    @course = Course.new(params[:course])
    if @course.save
      redirect_to :action => 'list_courses'
    else
      flash[:error] = 'Invalid values for the course'
#      redirect_to :action => 'new_course'
      render :template => 'curriculum/new_course'
    end
  end
  
end
