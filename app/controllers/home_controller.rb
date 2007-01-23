class HomeController < ApplicationController

  restrict_to :admin, :only => 'administrate'
    
  def index
    @document = Document.find_by_identifier('home_page')
  end
  
  def administrate
  end
    
end
