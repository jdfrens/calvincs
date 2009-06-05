class EventController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    @events = Event.find_by_semester_of
  end

  def show
    @event = Event.find(params[:id])
    @last_updated = @event.updated_at
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => :index
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new_event(params[:event])
    if @event.save
      redirect_to :action => :index
    else
      render :new
    end
  end

end
