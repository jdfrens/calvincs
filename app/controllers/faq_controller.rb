class FaqController < ApplicationController
  
  def index
    redirect_to :action => :list
  end
  
  def list
    render :nothing => true
  end
  
end
