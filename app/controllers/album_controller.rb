class AlbumController < ApplicationController

  restrict_to :admin, :only => [ :create, :list ]
  
  def create
    if params[:image]
      Image.create!(params[:image])
      redirect_to :action => 'list'
    else
    end
  end
  
  def list
    @images = Image.find(:all)
  end
  
end
