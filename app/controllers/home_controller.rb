class HomeController < ApplicationController

  restrict_to :edit, :only => 'administrate'
    
  def index
    @content = Page.find_by_identifier!('_home_page')
    @splash = Page.find_by_identifier!('_home_splash')
    @newsitems = Newsitem.find_current
    @todays_events = Event.find_by_today
    @this_weeks_events = Event.within_week
    @last_updated = last_updated(@newsitems + [@content, @splash])
    render
  rescue ActiveRecord::RecordNotFound => e
    id = @content ? "_home_splash" : "_home_page"
    redirect_to :controller => "pages", :action => "new", :id => id
  end
  
  def administrate
  end

  def feed
    
  end

end
