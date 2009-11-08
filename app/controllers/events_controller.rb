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
    start = Chronic.parse("tomorrow at 3:30pm")
    stop = start + 1.hour
    @event = Event.new_event(:kind => "Colloquium", :start => start, :stop => stop)
  end

  def create
    @event = Event.new_event(params[:colloquium] || params[:conference])
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
