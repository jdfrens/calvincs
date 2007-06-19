class AlbumController < ApplicationController

  restrict_to :edit
  
  def create
    if params[:image]
      image = Image.create!(params[:image])
      image.tags_string = params[:image][:tags_string]
      image.save!
      redirect_to :action => 'list'
    else
    end
  end
  
  def list
    @images = Image.find(:all)
  end
  
  def update_image
    image = Image.find(params[:id])
    image.update_attributes(params[:image])
    image.reload
    render :update do |p|
      p.replace_html "image_form_#{image.id}", :partial => 'image', :object => image
    end
  end
  
  def destroy_image
    image = Image.find(params[:id])
    image.destroy
    redirect_to :action => 'list'
  end
  
end
