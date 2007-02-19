class DocumentController < ApplicationController

  restrict_to :admin, :only => [
      :create, :save, :destroy,
      :set_page_title, :update_page_content, :set_page_identifier
  ]
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @pages = Page.find(:all)
    render :template => 'document/list'
  end
  
  def view
    @page = Page.find_by_identifier(params[:id])
    if @page
      render :template => 'document/view'
    else
      flash[:error] = "Page #{params[:id]} does not exist."
      redirect_to :action => 'list'
    end
  end
  
  def create
    @page = nil
  end
  
  # TODO: combine with create/new action
  def save
    @page = Page.new(params[:page])
    if @page.save
      redirect_to :action => 'view', :id => @page.identifier
    else
      flash[:error] = 'Invalid values for the page'
      render :template => 'document/create'
    end
  end
  
  in_place_edit_for :page, :title
  
  def update_page_content
    page = Page.find(params[:id])
    page.update_attribute(:content, params[:page][:content])
    render :update do |p|
      p.replace_html "page_content", :inline => page.render_content
    end
  end
  
  in_place_edit_for :page, :identifier

  def destroy
    Page.destroy(params[:id])
    redirect_to :action => 'list'
  end
  
end
