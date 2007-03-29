class HomeController < ApplicationController

  restrict_to :admin, :only => 'administrate'
    
  def index
    @content = Page.find_by_identifier('home_page')
    @splash = Page.find_by_identifier('home_splash')
  end
  
  def administrate
  end
    
end
