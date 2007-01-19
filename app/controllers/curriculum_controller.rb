class CurriculumController < ApplicationController

  layout "standard"
  
  def index
    redirect_to :action => 'list_courses'
  end
  
  def list_courses
    @courses = Course.find(:all, :order => "label, number")
  end
  
end
