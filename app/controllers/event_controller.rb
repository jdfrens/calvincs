class EventController < ApplicationController
  
  restrict_to :edit, :except => [ :index, :list, :view, ]
  
  def index
    redirect_to :action => :list
  end
  
  def list
    @events = Event.find_by_semester_of
  end
  
  def view
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => :list
  end
  
  def new
    @event = Event.new
  end

end