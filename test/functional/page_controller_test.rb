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
  
  def test_index_redirects_to_list
    get :index
    assert_redirected_to :controller => 'page', :action => 'list'
  end
  
  def test_create
    get :create, {}, user_session(:edit)
    assert_response :success
    assert_standard_layout
    assert_template "page/create"
    assert_select "h1", "Create Page"
    assert_page_form
  end
  
  def test_create_redirects_when_NOT_logged_in
    get :create
    assert_redirected_to_login
  end
  
  def test_list_WHEN_logged_in
    get :list, {}, user_session(:edit), { :error => 'Error flash!' }
    
    assert_response :success
    assert_standard_layout
    assert_template "page/list"
    assert_select "h1", "All Pages"
    assert_select "div#error", "Error flash!"
    assert_select "table[summary=page list]" do
      assert_select "tr", Page.count+1,
          "should have one row per page plus a header"
      assert_select "tr" do
        assert_select "th", /identifier/i
        assert_select "th", /title/i
      end
      assert_standard_page_entries
    end
    assert_select "a[href=/page/create]", "Create a new page"
  end
  
  def test_list_redirects_when_NOT_logged_in
    get :list
    
    assert_redirected_to_login
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
      assert_select "h1 #page_title_1_in_place_editor", false
      assert_select "p #page_content_1_in_place_editor", false
      assert_select "p.identifier #page_identifier_1_in_place_editor", false
    end
  end
  
  def test_view_404s_for_subpage_when_NOT_logged_in
    get :view, :id => '_home_page'
    
    assert_response 404
  end
  
  def test_view_of_subpage_WHEN_logged_in
    get :view, { :id => '_home_page' }, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    assert_select "div#content" do
      assert_select "h1", "{{ A SUBPAGE HAS NO TITLE }}"
      assert_select "h1 input#edit_title", false, "should not edit unused title"
      assert_select "div#page_content" do
        assert_select "p", strip_textile(pages(:home_page).content)
      end
    end
    assert_link_to_markup_help
    assert_select "form[action=/page/update_page_content/3]" do
      assert_select "textarea#page_content", pages(:home_page).content
      assert_select "input[type=submit][value=Update content]"
    end
    assert_select "p.identifier #page_identifier_3_in_place_editor",
        '_home_page'
  end
  
  def test_view_page_WITHOUT_image_and_when_NOT_logged_in
    get :view, :id => 'alphabet'
    
    assert_response :success
    assert_standard_layout
    assert_select "div#content div.img-right", false
  end
   
  def test_view_and_edit_page_WHEN_logged_in
    get :view, { :id => 'mission' }, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    assert_template "page/view"
    assert_select "div#content" do
      assert_select "div#page_content" do
        assert_select "p", 'We state our mission.'
        assert_select "p strong", "our"
      end
      assert_select "div[class=img-right]", false
      assert_select "h1 input#edit_title", true
      assert_select "h1 span#page_title_1_in_place_editor", "Mission Statement"
      assert_link_to_markup_help
      assert_select "form[action=/page/update_page_content/1]" do
        assert_select "textarea#page_content", 'We state *our* mission.'
        assert_select "input[type=submit][value=Update content]"
      end
      assert_select "p.identifier #page_identifier_1_in_place_editor",
          'mission'
    end
  end
  
  def test_view_redirects_with_page_that_does_not_exist_WHEN_logged_in
    get :view, { :id => 'does_not_exist' }, user_session(:edit)
    assert_redirected_to :action => 'list'
    assert_equal "Page does_not_exist does not exist.", flash[:error]
  end
  
  def test_view_404s_for_page_that_does_not_exist_when_NOT_logged_in
    get :view, { :id => 'does_not_exist' }
    
    assert_response 404
  end
  
  def test_save
    post :save,
        { :page => {
            :identifier => 'new_page', :title => 'New Page',
            :content => 'love me!'
          }
        }, user_session(:edit)

    assert_redirected_to :action => 'view', :id => 'new_page'
    assert flash.empty?

    page = Page.find_by_identifier('new_page')
    assert_not_nil page
    assert_equal 'love me!', page.content
  end
  
  def test_save_redirects_when_NOT_logged_in
    original_count = Page.count
    
    post :save,
        :page => {
          :identifier => 'new_page', :title => 'New Page',
          :content => 'love me!'
        }

    assert_redirected_to_login

    assert_equal original_count, Page.count, "should have #{original_count} pages still"
  end
  
  def test_save_fails_with_bad_data
    original_count = Page.count
    
    post :save,
        { :page => { :identifier => 'bad!', :content => 'whatever' } },
        user_session(:edit)
        
    assert_response :success
    assert !flash.empty?
    assert_equal 'Invalid values for the page', flash[:error]
    
    assert_equal original_count, Page.count, "should have only four pages still"
  end
  
  def test_set_page_title
    xhr :post, :set_page_title,
        { :id => 1, :value => 'New Mission Statement' },
        user_session(:edit)

    assert_response :success
    assert_equal "New Mission Statement", @response.body
    
    page = Page.find(1)
    assert_equal 'New Mission Statement', page.title
  end
  
  def test_set_page_title_redirects_when_NOT_logged_in
    xhr :post, :set_page_title, :id => 1, :value => 'New Mission Statement'
    
    assert_redirected_to_login
    
    assert_equal "Mission Statement", Page.find(1).title
  end
  
  def test_update_page_content
    xhr :post, :update_page_content,
        { :id => 1, :page => { :content => 'Mission *away*!' } },
        user_session(:edit)
        
    assert_response :success
    assert_select_rjs :replace_html, "page_content" do
      assert_select "p", "Mission away!"
      assert_select "strong", "away"
    end
    
    page = Page.find(1)
    assert_equal 'Mission *away*!', page.content
  end
  
  def test_update_page_content_redirects_when_NOT_logged_in
    xhr :get, :update_page_content,
        { :id => 1, :page => { :content => 'Mission away!' } }
    
    assert_redirected_to_login
    assert_equal "We state *our* mission.", Page.find(1).content
  end
  
  def test_set_page_identifier
    xhr :post, :set_page_identifier, { :id => 1, :value => 'mission_2'},
        user_session(:edit)
        
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
  
  def test_destroy
    post :destroy, { :id => 1 }, user_session(:edit)
    
    assert_redirected_to :controller => 'page', :action => 'list'

    assert_nil Page.find_by_identifier('mission')
  end
  
  def test_destroy_redirects_when_not_logged_in
    post :destroy, :id => 1
    
    assert_redirected_to_login
    
    assert_not_nil Page.find(1)
  end
  
  #
  # Helpers
  #
  private
  
  def assert_standard_page_entries
    assert_page_entry pages(:alphabet)
    assert_page_entry pages(:mission)
    assert_page_entry pages(:home_page)
    assert_page_entry pages(:home_splash)
    assert_page_entries_order
  end

  def assert_page_entries_order
    current_page = pages(:alphabet)
    [:mission, :home_page, :home_splash].each do |next_identifier|
      next_page = pages(next_identifier)
      assert_select "tr#page_#{current_page.id} ~ tr#page_#{next_page.id}", true,
          "page '#{current_page.identifier}' should be before '#{next_page.identifier}''"
      current_page = next_page
    end
  end

  def assert_page_entry(page)
    id = page.id
    identifier = page.identifier
    title = page.title
    assert_select "tr#page_#{page.id}" do
      if page.subpage?
        assert_select "td a[href=/p/#{identifier}]", "SUBPAGE (NO TITLE)"
      else
        assert_select "td a[href=/p/#{identifier}]", title,
            "should have title in appropriate <a> in <td>"
      end
      assert_select "td", identifier,
          "should have column with identifier in it"
      assert_select "form[action=/page/destroy/#{id}]" do
        assert_select "input[value=Destroy]", 1, "should have destroy button"
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
