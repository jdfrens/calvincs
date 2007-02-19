class HomeController < ApplicationController

  restrict_to :admin, :only => 'administrate'
    
  def index
    @page = Page.find_by_identifier('home_page')
  end
  
  def administrate
  end
    
end
