class DocumentController < ApplicationController

  restrict_to :admin, :only => [
      :create, :save, :destroy,
      :set_document_title, :update_document_content, :set_document_identifier
  ]
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @documents = Document.find(:all)
    render :template => 'document/list'
  end
  
  def view
    @document = Document.find_by_identifier(params[:id])
    if @document
      render :template => 'document/view'
    else
      flash[:error] = "Document #{params[:id]} does not exist."
      redirect_to :action => 'list'
    end
  end
  
  # TODO: refactor 'create' as 'new' to fit standard scaffold better
  def create
    @document = nil
  end
  
  # TODO: combine with create/new action
  def save
    @document = Document.new(params[:document])
    if @document.save
      redirect_to :action => 'view', :id => @document.identifier
    else
      flash[:error] = 'Invalid values for the document'
      render :template => 'document/create'
    end
  end
  
  in_place_edit_for :document, :title
  
  def update_document_content
    document = Document.find(params[:id])
    document.update_attribute(:content, params[:document][:content])
    render :update do |page|
      page.replace_html "document_content", :inline => document.render_content
    end
  end
  
  in_place_edit_for :document, :identifier

  def destroy
    Document.destroy(params[:id])
    redirect_to :action => 'list'
  end
  
end
