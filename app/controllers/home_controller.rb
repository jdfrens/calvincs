class HomeController < ApplicationController

  layout "standard"
    
  def index
    @document = Document.find_by_identifier('home_page')
  end
  
  def administrate
  end
    
end
