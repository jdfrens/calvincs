class PageController < ApplicationController

  restrict_to :edit, :except => [ :index, :list, :view, ]
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @pages = Page.find(:all, :order => 'identifier ASC')
    render :template => 'page/list'
  end
  
  def view
    @page = Page.find_by_identifier(params[:id])
    if @page
      if @page.subpage? && !current_user
        render :inline => "<p>This page does not exist.</p>", :layout => "application", :status => 404
      else
        @image = @page.random_image
        render :template => 'page/view'
      end
    elsif current_user
      flash[:error] = "Page #{params[:id]} does not exist."
      redirect_to :action => 'list'
    else
      render :text => "<p>This page does not exist.</p>", :layout => "application", :status => 404
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
      render :template => 'page/create'
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
