class HomeController < ApplicationController

  restrict_to :edit, :only => 'administrate'

  def index
    @content = Page.find_by_identifier('_home_page')
    @splash_image = Image.pick_random('homepage')
    @newsitems = Newsitem.find_current
    @todays_events = Event.find_by_today
    @this_weeks_events = Event.within_week
    if @content.nil?
      redirect_to :controller => "pages", :action => "new", :id => '_home_page'
    elsif @splash_image.nil?
      render :text => "need an image tagged 'homepage'"
    else
      @last_updated = last_updated(@newsitems + [@content])      
    end
  end

  def administrate
  end

  def feed
    @newsitems = Newsitem.find_current
    @todays_events = Event.find_by_today
    @weeks_events = Event.within_week
    @updated_at = @newsitems.maximum(:updated_at)

    respond_to do |format|
      format.atom
    end
  end

end
