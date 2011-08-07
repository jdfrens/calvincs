class EventsController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    if params[:year] == "all"
      @title = "Events Archive"
      @years = Event.years_of_events
      render :archive
    elsif params[:year] =~ /^\d{4}$/
      @title = "Events of #{params[:year]}"
      @events = Event.by_year(params[:year])
    else
      @title = "Upcoming Events"
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
    start, stop = Event.default_start_and_stop
    @event = Event.new(:event_kind => params[:event_kind], :descriptor => params[:event_kind].downcase, :start => start, :stop => stop)
  end

  def create
    @event = Event.new(params[:event])
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
    event.update_attributes(params[:event])
    if event.save
      redirect_to events_path
    else
      render :edit
    end
  end

end
