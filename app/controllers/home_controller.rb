class HomeController < ApplicationController

  restrict_to :edit, :only => 'administrate'
    
  def index
    @content = Page.find_by_identifier('_home_page')
    @splash = Page.find_by_identifier('_home_splash')
    @news_items = NewsItem.find_current
    @last_updated = (news_times + page_times).max
  end
  
  def administrate
  end

  #
  # Helper
  #
  private
  
  def news_times
    @news_items.map(&:updated_at)
  end
  
  def page_times
    [@content.updated_at, @splash.updated_at]
  end
    
end
