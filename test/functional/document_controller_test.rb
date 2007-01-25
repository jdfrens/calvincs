require File.dirname(__FILE__) + '/../test_helper'
require 'document_controller'

# Re-raise errors caught by the controller.
class DocumentController; def rescue_action(e) raise e end; end

class DocumentControllerTest < Test::Unit::TestCase
  
  fixtures :documents, :users, :groups, :privileges, :groups_privileges
  
  def setup
    @controller = DocumentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  should "redirect index to list" do
    get :index
    assert_redirected_to :controller => 'document', :action => 'list'
  end
  
  should "get form to create a new document when logged in" do
    get :create, {}, { :current_user_id => 1 }
    assert_response :success
    assert_standard_layout
    assert_template "document/create"
    assert_select "h1", "Create Document"
    assert_document_form
  end
  
  should "redirect when trying to create a new document and NOT logged in" do
    get :create
    assert_redirected_to_login
  end
  
  should "get a list of documents when logged in" do
    get :list, {}, { :current_user_id => 1 }
    assert_response :success
    assert_standard_layout
    assert_template "document/list"
    assert_select "h1", "All Documents"
    assert_select "ul" do
      assert_select "li a[href=/document/view/mission_statement]", "Mission Statement"
      assert_select "form[action=/document/destroy/1]" do
        assert_select "input[value=Destroy]"
      end
      assert_select "li a[href=/document/view/alphabet]", "The Alphabet"
      assert_select "form[action=/document/destroy/2]" do
        assert_select "input[value=Destroy]"
      end
    end
  end
  
  should "get a list of documents when NOT logged in" do
    get :list
    assert_response :success
    assert_standard_layout
    assert_template "document/list"
    assert_select "h1", "All Documents"
    assert_select "ul" do
      assert_select "li a[href=/document/view/mission_statement]", "Mission Statement"
      assert_select "form[action=/document/destroy/1]", 0
      assert_select "li a[href=/document/view/alphabet]", "The Alphabet"
      assert_select "form[action=/document/destroy/2]", 0
    end
  end
  
  should "save a new document" do
    post :save,
        { :document => {
          :identifier => 'new_document', :title => 'New Document',
          :content => 'love me!'
          }
        }, { :current_user_id => 1 }
    assert_redirected_to :action => 'view', :id => 'new_document'
    assert flash.empty?
    document = Document.find_by_identifier('new_document')
    assert_not_nil document
    assert_equal 'love me!', document.content
  end
  
  should "fail to save a new document when NOT logged in" do
    post :save,
        :document => {
          :identifier => 'new_document', :title => 'New Document',
          :content => 'love me!'
        }
    assert_redirected_to_login
    assert_equal 3, Document.find(:all).size,
        "should have only three documents still"
  end
  
  should "fail to save a new document with bad identifier" do
    post :save,
        { :document => { :identifier => 'bad!', :content => 'whatever' } },
        { :current_user_id => 1 }
    assert_response :success
    assert !flash.empty?
    assert_equal 'Invalid values for the document', flash[:error]
    assert_equal 3, Document.find(:all).size,
        "should have only three documents still"
  end
  
  should "view a document" do
    get :view, :id => 'mission_statement'
    assert_response :success
    assert_standard_layout
    assert_template "document/view"
    assert_select "h1", "Mission Statement"
    assert_select "p", 'We state our mission.'
    assert_select "p strong", "our"

    assert_select "h1 span#document_title_1_in_place_editor", false
    assert_select "p span#document_content_1_in_place_editor", false
    assert_select "p[class=identifier] span#document_identifier_1_in_place_editor", false
  end
  
  should "view a document when logged in" do
    get :view, { :id => 'mission_statement' }, { :current_user_id => 1 } 
    assert_response :success
    assert_standard_layout
    assert_template "document/view"
    assert_select "p", 'We state our mission.'
    assert_select "p strong", "our"

    assert_select "h1 span#document_title_1_in_place_editor", "Mission Statement"
    assert_select "p span#document_content_1_in_place_editor", 'We state *our* mission.'
    assert_select "p[class=identifier] span#document_identifier_1_in_place_editor", 'mission_statement'
  end
  
  should "change document title" do
    get :set_document_title,
        { :id => 1, :value => 'New Mission Statement' },
        { :current_user_id => 1 }
    assert_response :success
    document = Document.find(1)
    assert_equal 'New Mission Statement', document.title
  end
  
  should "fail to change document title when NOT logged in" do
    get :set_document_title, :id => 1, :value => 'New Mission Statement'
    assert_redirected_to_login
    assert_equal "Mission Statement", Document.find(1).title
  end
  
  should "change document content" do
    get :set_document_content,
        { :id => 1, :value => 'Mission away!' },
        { :current_user_id => 1 }
    assert_response :success
    document = Document.find(1)
    assert_equal 'Mission away!', document.content
  end
  
  should "fail to change document content when NOT logged in" do
    get :set_document_content, :id => 1, :value => 'Mission away!'
    assert_redirected_to_login
    assert_equal "We state *our* mission.", Document.find(1).content
  end
  
  should "change document identifier" do
    get :set_document_identifier,
        { :id => 1, :value => 'mission_statement_2'},
        { :current_user_id => 1 }
    assert_response :success
    document = Document.find(1)
    assert_equal 'mission_statement_2', document.identifier
  end
  
  should "fail to change document identifier when NOT logged in" do
    get :set_document_identifier, :id => 1, :value => 'mission_statement_2'
    assert_redirected_to_login
    assert_equal "mission_statement", Document.find(1).identifier
  end
  
  should "redirect when trying to view non-existant document" do
    get :view, :id => 'does_not_exist'
    assert_redirected_to :action => 'list'
  end
  
  should "destroy a document when logged in" do
    post :destroy, { :id => 1 }, { :current_user_id => 1 }
    assert_redirected_to :action => 'list'
    document = Document.find_by_identifier('mission_statement')
    assert_nil document
  end
  
  should "redirect to login when trying to destroy a document and NOT logged in" do
    post :destroy, :id => 1
    assert_redirected_to_login
    assert_not_nil Document.find(1)
  end
  
  #
  # Helpers
  #
  private
  
  def assert_document_form
    assert_select "input#document_identifier"
    assert_select "input#document_title"
    assert_select "textarea#document_content"
    assert_select "input[type=submit]"
  end
  
end
