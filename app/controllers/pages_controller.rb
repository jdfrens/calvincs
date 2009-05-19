class PagesController < ApplicationController

  restrict_to :edit, :except => [ :show ]
  
  def index
    @pages = Page.find(:all, :order => 'identifier ASC')
  end
  
  def show
    @page = Page.find_by_an_id(params[:id])
    if @page
      if @page.subpage?
        render :template => "errors/404.html", :status => 404
      else
        @image = @page.random_image
        @title = @page.subpage? ? "SUBPAGE" : @page.title
        @last_updated = @page.updated_at
        render :template => 'pages/show'
      end
    elsif current_user
      flash[:error] = "Page #{params[:id]} does not exist."
      redirect_to :action => 'index'
    else
      render :template => "errors/404.html", :status => 404
    end
  end

  def edit
    @page = Page.find_by_an_id(params[:id])
  end

  def new
    @page = Page.new(:identifier => params[:id])
  end
  
  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to :action => 'show', :id => @page.identifier
    else
      flash[:error] = 'Invalid values for the page'
      render :template => 'pages/new'
    end
  end
  
  def destroy
    Page.destroy(params[:id])
    redirect_to :action => 'index'
  end

  in_place_edit_for :page, :title
  
  def update_page_content
    page = Page.find(params[:id])
    page.update_attribute(:content, params[:page][:content])
    render :update do |p|
      p.replace_html "page_content", :inline => textilize(page.content)
    end
  end
  
  in_place_edit_for :page, :identifier

end
