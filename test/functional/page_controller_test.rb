require File.dirname(__FILE__) + '/../test_helper'
require 'page_controller'

# Re-raise errors caught by the controller.
class PageController; def rescue_action(e) raise e end; end

class PageControllerTest < Test::Unit::TestCase
  
  fixtures :pages, :users, :groups, :privileges, :groups_privileges
  
  def setup
    @controller = PageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  should "redirect index to list" do
    get :index
    assert_redirected_to :controller => 'page', :action => 'list'
  end
  
  should "get form to create a new document when logged in" do
    get :create, {}, { :current_user_id => 1 }
    assert_response :success
    assert_standard_layout
    assert_template "page/create"
    assert_select "h1", "Create Page"
    assert_page_form
  end
  
  should "redirect when trying to create a new document and NOT logged in" do
    get :create
    assert_redirected_to_login
  end
  
  should "get a list of documents when logged in" do
    get :list, {}, { :current_user_id => 1 }, { :error => 'Error flash!' }
    assert_response :success
    assert_standard_layout
    assert_template "page/list"
    assert_select "h1", "All Pages"
    assert_select "div#error", "Error flash!"
    assert_select "table[summary=page list]" do
      assert_select "tr", 4, "should be three page and one header"
      assert_select "tr" do
        assert_select "th", /identifier/i
        assert_select "th", /title/i
      end
      assert_page_entry 1, 'mission_statement', "Mission Statement"
      assert_page_entry 2, 'alphabet', "The Alphabet"
      assert_page_entry 3, 'home_page', "Computing at Calvin College"
    end
    assert_select "a[href=/page/create]", "Create a new page"
  end
  
  should "get a list of documents when NOT logged in" do
    get :list, {}, {}, { :error => 'Error flash!' }
    assert_response :success
    assert_standard_layout
    assert_template "page/list"
    assert_select "h1", "All Pages"
    assert_select "div#error", "Error flash!"
    assert_select "table[summary=page list]" do
      assert_select "tr", 3, "should be three pages in fixtures"
      assert_page_entry 1, 'mission_statement', "Mission Statement"
      assert_page_entry 2, 'alphabet', "The Alphabet"
      assert_page_entry 3, 'home_page', "Computing at Calvin College"
    end
    assert_select "a[href=/page/create]", 0
  end
  
  should "view a document when NOT logged in" do
    get :view, :id => 'mission_statement'
    assert_response :success
    assert_standard_layout
    assert_template "page/view"
    assert_select "h1", "Mission Statement"
    assert_select "div#page_content p", 'We state our mission.'
    assert_select "div#page_content p strong", "our"

    assert_select "h1 span#page_title_1_in_place_editor", false
    assert_select "p span#page_content_1_in_place_editor", false
    assert_select "p[class=identifier] span#page_identifier_1_in_place_editor", false
  end
  
  should "view a document when logged in" do
    get :view, { :id => 'mission_statement' }, { :current_user_id => 1 } 
    assert_response :success
    assert_standard_layout
    assert_template "page/view"
    assert_select "div#page_content p", 'We state our mission.'
    assert_select "div#page_content p strong", "our"

    assert_select "h1 span#page_title_1_in_place_editor", "Mission Statement"
    assert_select "p a[href=http://hobix.com/textile/][target=_blank]", "Textile reference"
    assert_select "form[action=/page/update_page_content/1]" do
      assert_select "textarea#page_content", 'We state *our* mission.'
      assert_select "input[type=submit][value=Update content]"
    end
    assert_select "p[class=identifier] span#page_identifier_1_in_place_editor", 'mission_statement'
  end
  
  should "redirect when trying to view non-existant document" do
    get :view, :id => 'does_not_exist'
    assert_redirected_to :action => 'list'
    assert_equal "Page does_not_exist does not exist.", flash[:error]
  end
  
  should "save a new document" do
    post :save,
        { :page => {
          :identifier => 'new_document', :title => 'New Page',
          :content => 'love me!'
          }
        }, { :current_user_id => 1 }
    assert_redirected_to :action => 'view', :id => 'new_document'
    assert flash.empty?
    document = Page.find_by_identifier('new_document')
    assert_not_nil document
    assert_equal 'love me!', document.content
  end
  
  should "fail to save a new document when NOT logged in" do
    post :save,
        :page => {
          :identifier => 'new_document', :title => 'New Page',
          :content => 'love me!'
        }
    assert_redirected_to_login
    assert_equal 3, Page.find(:all).size,
        "should have only three documents still"
  end
  
  should "fail to save a new document with bad identifier" do
    post :save,
        { :page => { :identifier => 'bad!', :content => 'whatever' } },
        { :current_user_id => 1 }
    assert_response :success
    assert !flash.empty?
    assert_equal 'Invalid values for the page', flash[:error]
    assert_equal 3, Page.find(:all).size,
        "should have only three documents still"
  end
  
  should "change document title" do
    xhr :get, :set_page_title,
        { :id => 1, :value => 'New Mission Statement' },
        { :current_user_id => 1 }
    assert_response :success
    assert_equal "New Mission Statement", @response.body

    document = Page.find(1)
    assert_equal 'New Mission Statement', document.title
  end
  
  should "fail to change document title when NOT logged in" do
    xhr :get, :set_page_title, :id => 1, :value => 'New Mission Statement'
    assert_redirected_to_login
    assert_equal "Mission Statement", Page.find(1).title
  end
  
  should "change document content" do
    xhr :get, :update_page_content,
        { :id => 1, :page => { :content => 'Mission *away*!' } },
        { :current_user_id => 1 }
    assert_response :success
    assert_select_rjs :replace_html, "page_content" do
      assert_select "p", "Mission away!"
      assert_select "strong", "away"
    end
    
    document = Page.find(1)
    assert_equal 'Mission *away*!', document.content
  end
  
  should "fail to change document content when NOT logged in" do
    xhr :get, :update_page_content,
        { :id => 1, :page => { :content => 'Mission away!' } }
    assert_redirected_to_login
    assert_equal "We state *our* mission.", Page.find(1).content
  end
  
  should "change document identifier" do
    xhr :get, :set_page_identifier,
        { :id => 1, :value => 'mission_statement_2'},
        { :current_user_id => 1 }
    assert_response :success
    assert_equal "mission_statement_2", @response.body

    document = Page.find(1)
    assert_equal 'mission_statement_2', document.identifier
  end
  
  should "fail to change document identifier when NOT logged in" do
    xhr :get, :set_page_identifier, :id => 1, :value => 'phooey'
    assert_redirected_to_login
    assert_equal "mission_statement", Page.find(1).identifier
  end
  
  should "destroy a document when logged in" do
    post :destroy, { :id => 1 }, { :current_user_id => 1 }
    assert_redirected_to :action => 'list'
    document = Page.find_by_identifier('mission_statement')
    assert_nil document
  end
  
  should "redirect to login when trying to destroy a document and NOT logged in" do
    post :destroy, :id => 1
    assert_redirected_to_login
    assert_not_nil Page.find(1)
  end
  
  #
  # Helpers
  #
  private
  
  def assert_page_entry(id, identifier, title)
      assert_select "td a[href=/p/#{identifier}]", title,
          "should have title in appropriate <a> in <td>"
      if is_logged_in
        assert_select "td", identifier,
            "should have column with identifier in it"
        assert_select "form[action=/page/destroy/#{id}]" do
          assert_select "input[value=Destroy]", 1, "should have destroy button"
        end
      else
        assert_select "form[action=/page/destroy/#{id}]", 0,
            "should be no destroy form when NOT logged in"
      end
  end
  
  def assert_page_form
    assert_select "input#page_identifier"
    assert_select "input#page_title"
    assert_select "textarea#page_content"
    assert_select "input[type=submit]"
  end
  
end
