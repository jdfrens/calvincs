class EventController < ApplicationController
  
  def index
    redirect_to :action => :list
  end
  
  def list
    
  end
  
  def view
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => :list
  end
  
end
