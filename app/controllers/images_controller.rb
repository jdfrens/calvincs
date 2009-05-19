class ImagesController < ApplicationController

  restrict_to :edit

  def index
    @images = Image.find(:all)
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

  def update
    @image = Image.find(params[:id])
    @image.update_attributes(params[:image])
    @image.tags_string = params[:image][:tags_string]
    @image.save!
    @image.reload
    respond_to do |format|
      format.js
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
    redirect_to :action => 'index'
  end

end