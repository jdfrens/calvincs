class CurriculumController < ApplicationController

  layout "standard"
  
  def index
    redirect_to :action => 'list_courses'
  end
  
  def list_courses
    @courses = Course.find(:all, :order => "label, number")
  end
  
  def new_course
    @course = nil
    render :template => 'curriculum/course_form'
  end

  def view_course
    begin
      @course = Course.find(params[:id])
      render :template => 'curriculum/course_detail'
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => 'list_courses'
    end
  end
  
  def save_course
    @course = Course.new(params[:course])
    if @course.save
      redirect_to :action => 'list_courses'
    else
      flash[:error] = 'Invalid values for the course'
      render :template => 'curriculum/course_form'
    end
  end
  
end
