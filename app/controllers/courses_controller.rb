class CoursesController < ApplicationController

  restrict_to :edit, :except => [:index, :show]

  def index
    @courses = Course.find(:all, :order => "department, number")
  end

  def show
    @course = Course.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => 'index'
  end

  def new
    @course = Course.new
  end

  def save
    @course = Course.new(params[:course])
    if @course.save
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid values for the course'
      render :template => 'courses/new'
    end
  end

end
