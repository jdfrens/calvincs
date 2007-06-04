require File.dirname(__FILE__) + '/../test_helper'
require 'album_controller'

# Re-raise errors caught by the controller.
class AlbumController; def rescue_action(e) raise e end; end

class AlbumControllerTest < Test::Unit::TestCase

  fixtures :images, :users, :groups_privileges, :groups, :privileges

  def setup
    @controller = AlbumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list
    get :list, {}, user_session(:admin)
    
    assert_response :success
    assert_standard_layout
    assert_select "h1", "List of Images"
    assert_select "ul#image_list" do
      assert_select "li", 3, "should be three images"
      assert_select "li", images(:mission_statement_image).url
      assert_select "li", images(:alphabet_image).url
      assert_select "li", images(:mission_statement_image2).url
    end
  end
  
  def test_list_redirects_when_NOT_logged_in
    get :list
    assert_redirected_to_login
  end
  
  def test_new_image_form
    get :create, {}, user_session(:admin)
    
    assert_response :success
    assert_standard_layout
    assert_select "form[action=/album/create]" do
      assert_select "input#image_url", 1
      assert_select "input#image_caption", 1
      assert_select "input#image_tag", 1
      assert_select "input[type=submit]", 1
    end
  end
  
  def test_new_image_creation
    get :create,
        { :image => { :url => "http://example.com/foo.gif",
                      :caption => "Foo is bar!",
                      :tag => "foobar" }},
        user_session(:admin)
    
    assert_redirected_to :action => 'list'
    image = Image.find_by_tag("foobar")
    assert_not_nil image
    assert_equal "http://example.com/foo.gif", image.url
    assert_equal "Foo is bar!", image.caption
  end
  
  def test_new_image_form_redirects_when_NOT_logged_in
    get :create
    assert_redirected_to_login
  end
  
end
