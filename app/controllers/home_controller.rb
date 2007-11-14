class HomeController < ApplicationController

  restrict_to :edit, :only => 'administrate'
    
  def index
    @content = Page.find_by_identifier('_home_page')
    @splash = Page.find_by_identifier('_home_splash')
    @news_items = NewsItem.find_current
    @todays_events = Event.find_by_today
    @this_weeks_events = Event.find_by_week_of(Time.now)
    @last_updated = last_updated(@news_items + [@content, @splash])
  end
  
  def administrate
  end
    
end
