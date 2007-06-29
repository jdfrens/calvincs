class HomeController < ApplicationController

  restrict_to :edit, :only => 'administrate'
    
  def index
    @content = Page.find_by_identifier('_home_page')
    @splash = Page.find_by_identifier('_home_splash')
    @news_items = NewsItem.find_current
  end
  
  def administrate
  end
    
end
