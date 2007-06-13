require File.dirname(__FILE__) + '/../test_helper'
require 'page_controller'

# Re-raise errors caught by the controller.
class PageController; def rescue_action(e) raise e end; end

class PageControllerTest < Test::Unit::TestCase
  
  fixtures :pages, :images, :image_tags
  user_fixtures
  
  def setup
    @controller = PageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  should "redirect index to list" do
    get :index
    assert_redirected_to :controller => 'page', :action => 'list'
  end
  
  should "get form to create a new page when logged in" do
    get :create, {}, user_session(:admin)
    assert_response :success
    assert_standard_layout
    assert_template "page/create"
    assert_select "h1", "Create Page"
    assert_page_form
  end
  
  should "redirect when trying to create a new page and NOT logged in" do
    get :create
    assert_redirected_to_login
  end
  
  should "get a list of pages when logged in" do
    get :list, {}, user_session(:admin), { :error => 'Error flash!' }
    assert_response :success
    assert_standard_layout
    assert_template "page/list"
    assert_select "h1", "All Pages"
    assert_select "div#error", "Error flash!"
    assert_select "table[summary=page list]" do
      assert_select "tr", 4+1, "should be four pages and one header"
      assert_select "tr" do
        assert_select "th", /identifier/i
        assert_select "th", /title/i
      end
      assert_standard_page_entries
    end
    assert_select "a[href=/page/create]", "Create a new page"
  end
  
  should "get a list of pages when NOT logged in" do
    get :list, {}, {}, { :error => 'Error flash!' }
    assert_response :success
    assert_standard_layout
    assert_template "page/list"
    assert_select "h1", "All Pages"
    assert_select "div#error", "Error flash!"
    assert_select "table[summary=page list]" do
      assert_select "tr", 4, "should be four pages in fixtures"
      assert_standard_page_entries
    end
    assert_select "a[href=/page/create]", 0
  end
  
  def test_view_page_when_NOT_logged_in
    get :view, :id => 'mission'
    
    assert_response :success
    assert_standard_layout
    assert_template "page/view"
    assert_select "div#content" do
      assert_select "h1", "Mission Statement"
      assert_select "div#page_content" do
        assert_select "p", 'We state our mission.'
        assert_select "p strong", "our"
      end
      assert_select "div.img-right" do
        assert_select "img#cool-pic"
        assert_select "p.img-caption", assigns(:image).caption.gsub("*", "")
      end
      assert_select "h1 span#page_title_1_in_place_editor", false
      assert_select "p span#page_content_1_in_place_editor", false
      assert_select "p[class=identifier] span#page_identifier_1_in_place_editor", false
    end
  end
  
  def test_view_page_WITHOUT_image_and_when_NOT_logged_in
    get :view, :id => 'alphabet'
    
    assert_response :success
    assert_standard_layout
    assert_select "div#content div.img-right" do
      assert_select "img", false
      assert_select "p.img-caption", false
    end
  end
   
  def test_view_and_edit_page_when_logged_in
    get :view, { :id => 'mission' }, user_session(:admin) 
    assert_response :success
    assert_standard_layout
    assert_template "page/view"
    assert_select "div#content" do
      assert_select "div#page_content" do
        assert_select "p", 'We state our mission.'
        assert_select "p strong", "our"
      end
      assert_select "div[class=img-right]", "no images when editing"
      assert_select "h1 input#edit_title", 1
      assert_select "h1 span#page_title_1_in_place_editor", "Mission Statement"
      assert_link_to_markup_help
      assert_select "form[action=/page/update_page_content/1]" do
        assert_select "textarea#page_content", 'We state *our* mission.'
        assert_select "input[type=submit][value=Update content]"
      end
      assert_select "p[class=identifier] span#page_identifier_1_in_place_editor",
          'mission'
    end
  end
  
  should "redirect when trying to view non-existant page" do
    get :view, :id => 'does_not_exist'
    assert_redirected_to :action => 'list'
    assert_equal "Page does_not_exist does not exist.", flash[:error]
  end
  
  should "save a new page" do
    post :save,
    { :page => {
        :identifier => 'new_page', :title => 'New Page',
        :content => 'love me!'
      }
    }, user_session(:admin)
    assert_redirected_to :action => 'view', :id => 'new_page'
    assert flash.empty?
    page = Page.find_by_identifier('new_page')
    assert_not_nil page
    assert_equal 'love me!', page.content
  end
  
  should "fail to save a new page when NOT logged in" do
    post :save,
    :page => {
      :identifier => 'new_page', :title => 'New Page',
      :content => 'love me!'
    }
    assert_redirected_to_login
    assert_equal 4, Page.find(:all).size,
        "should have only four pages still"
  end
  
  should "fail to save a new page with bad identifier" do
    post :save,
    { :page => { :identifier => 'bad!', :content => 'whatever' } },
    user_session(:admin)
    assert_response :success
    assert !flash.empty?
    assert_equal 'Invalid values for the page', flash[:error]
    assert_equal 4, Page.find(:all).size,
        "should have only four pages still"
  end
  
  should "change page title" do
    xhr :get, :set_page_title,
    { :id => 1, :value => 'New Mission Statement' },
    user_session(:admin)
    assert_response :success
    assert_equal "New Mission Statement", @response.body
    
    page = Page.find(1)
    assert_equal 'New Mission Statement', page.title
  end
  
  should "fail to change page title when NOT logged in" do
    xhr :get, :set_page_title, :id => 1, :value => 'New Mission Statement'
    assert_redirected_to_login
    assert_equal "Mission Statement", Page.find(1).title
  end
  
  def test_update_page_content
    xhr :get, :update_page_content,
        { :id => 1, :page => { :content => 'Mission *away*!' } },
        user_session(:admin)
        
    assert_response :success
    assert_select_rjs :replace_html, "page_content" do
      assert_select "p", "Mission away!"
      assert_select "strong", "away"
    end
    
    page = Page.find(1)
    assert_equal 'Mission *away*!', page.content
  end
  
  should "fail to change page content when NOT logged in" do
    xhr :get, :update_page_content,
    { :id => 1, :page => { :content => 'Mission away!' } }
    assert_redirected_to_login
    assert_equal "We state *our* mission.", Page.find(1).content
  end
  
  should "change page identifier" do
    xhr :get, :set_page_identifier, { :id => 1, :value => 'mission_2'},
    user_session(:admin)
    assert_response :success
    assert_equal "mission_2", @response.body
    
    page = Page.find(1)
    assert_equal 'mission_2', page.identifier
  end
  
  def test_set_page_identifier_fails_when_NOT_logged_in
    xhr :get, :set_page_identifier, :id => 1, :value => 'phooey'
    assert_redirected_to_login
    assert_equal "mission", Page.find(1).identifier
  end
  
  should "destroy a page when logged in" do
    post :destroy, { :id => 1 }, user_session(:admin)
    
    assert_redirected_to :controller => 'page', :action => 'list'
    assert_nil Page.find_by_identifier('mission')
  end
  
  should "redirect to login when trying to destroy a page and NOT logged in" do
    post :destroy, :id => 1
    
    assert_redirected_to_login
    assert_not_nil Page.find(1)
  end
  
  #
  # Helpers
  #
  private
  
  def assert_standard_page_entries
    offset = logged_in? ? 1 : 0
    assert_page_entry 1+offset, pages(:alphabet)
    assert_page_entry 2+offset, pages(:home_page)
    assert_page_entry 3+offset, pages(:home_splash)
    assert_page_entry 4+offset, pages(:mission)
  end
  
  def assert_page_entry(n, page)
    id = page.id
    identifier = page.identifier
    title = page.title
    assert_select "tr#page_#{page.id}:nth-child(#{n})" do
      assert_select "td a[href=/p/#{identifier}]", title,
          "should have title in appropriate <a> in <td>"
      if logged_in?
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
  end
  
  def assert_page_form
    assert_select "form[action=/page/save]" do
      assert_select "input#page_identifier", 1
      assert_select "input#page_title", 1
      assert_select "textarea#page_content", 1
      assert_select "input[type=submit]", 1
    end
  end
  
end
