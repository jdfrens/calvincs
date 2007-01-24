class DocumentController < ApplicationController

  in_place_edit_for :document, :title
  in_place_edit_for :document, :content
  in_place_edit_for :document, :identifier
  
  restrict_to :admin, :only => [
      :create, :save, :destroy,
      :set_document_title, :set_document_content, :set_document_identifier
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
      redirect_to :action => 'list'
    end
  end
  
  def create
    @document = nil
  end
  
  def save
    @document = Document.new(params[:document])
    if @document.save
      redirect_to :action => 'view', :id => @document.identifier
    else
      flash[:error] = 'Invalid values for the document'
      render :template => 'document/create'
    end
  end
  
  def destroy
    Document.destroy(params[:id])
    redirect_to :action => 'list'
  end
  
end
