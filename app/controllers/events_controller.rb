class EventsController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    if params[:year]
      @years = Event.years_of_events
      render :archive
    else
      @events = Event.upcoming
    end
  end

  def show
    @event = Event.find(params[:id])
    @last_updated = @event.updated_at
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new_event(params[:event])
    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])
    event.update_attributes(params[:event] || params[:colloquium] || params[:conference])
    if event.save
      redirect_to events_path
    else
      render :edit
    end
  end

end
