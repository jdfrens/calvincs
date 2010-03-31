class ImagesController < ApplicationController

  restrict_to :edit

  def index
    @images = Image.find(:all, :include => [:image_tags])
  end

  def new
    @image = Image.new
  end

  def create
    image = Image.create!(params[:image])
    image.tags_string = params[:image][:tags_string]
    image.save!
    redirect_to :action => 'index'
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    image = Image.find(params[:id])
    image.update_attributes(params[:image])
    image.tags_string = params[:image][:tags_string]
    image.save!
    redirect_to(images_path)
  end

  def refresh
    Image.refresh_dimensions!
    redirect_to(images_path)
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
    redirect_to :action => 'index'
  end

end
