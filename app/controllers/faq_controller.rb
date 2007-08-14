class FaqController < ApplicationController
  
  restrict_to :edit, :except => [ :index, :list, ]

  def index
    redirect_to :action => :list
  end
  
  def list
    render :nothing => true
  end

  def create
    if request.post?
      @faq = Faq.create(params[:faq])
      if @faq.valid?
        redirect_to :action => :view, :id => @faq.identifier
      else
        render
      end
    else
      render
    end
  end
end
