require File.dirname(__FILE__) + '/../test_helper'
require 'album_controller'

# Re-raise errors caught by the controller.
class AlbumController; def rescue_action(e) raise e end; end

class AlbumControllerTest < Test::Unit::TestCase
  
  fixtures :images, :image_tags
  user_fixtures
  
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
    assert_select "div#image_list" do
      assert_select "table", 3, "should be three images"
      assert_select "div#image_form_1", 1
      assert_image_table images(:mission)
      assert_select "div#image_form_2", 1
      assert_image_table images(:alphabet)
      assert_select "div#image_form_3", 1
      assert_image_table images(:mission2)
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
      assert_select "input#image_url"
      assert_select "textarea#image_caption"
      assert_select "input#image_tags_string"
      assert_select "input[type=submit]"
    end
  end
  
  def test_new_image_creation
    get :create,
        { :image => { :url => "http://example.com/foo.gif",
            :caption => "Foo is bar!",
            :tags_string => "foobar barfoo" }},
        user_session(:admin)
    
    assert_redirected_to :action => 'list'
    image = Image.find_by_caption("Foo is bar!")
    assert_not_nil image
    assert_equal "http://example.com/foo.gif", image.url
    assert_equal "Foo is bar!", image.caption
    assert_equal ["foobar", "barfoo"], image.tags
  end
  
  def test_new_image_form_redirects_when_NOT_logged_in
    original_image_count = Image.find(:all).size
    original_tag_count = ImageTag.find(:all).size
    
    get :create,
        { :image => { :url => "http://example.com/foo.gif",
            :caption => "Foo is bar!",
            :tags_string => "foo bar" }}
    
    assert_redirected_to_login
    assert_equal original_image_count, Image.find(:all).size,
        "shouldn't add new image"
    assert_equal original_tag_count, ImageTag.find(:all).size,
        "shouldn't add new image tags"
  end
  
  def test_update_image
    image = Image.find(2)
    assert_equal "http://calvin.edu/abcd.png", image.url
    assert_equal "A B C, indeed!", image.caption
    assert_equal "", image.tags_string
  
    xhr :post, :update_image, 
        { :id => 2,
          :image => { :url => "http://example.com/lovely.gif",
            :caption => "Lovely.",
            :tags_string => "very lovely" }},
        user_session(:admin)

    image.reload
    assert_equal "http://example.com/lovely.gif", image.url
    assert_equal "Lovely.", image.caption
    assert_equal "very lovely", image.tags_string

    assert_response :success
    assert_select_rjs :replace_html, "image_form_2" do
      assert_image_table image
    end
  end
  
  def test_update_image_fails_when_NOT_logged_in
    xhr :post, :update_image, 
        { :id => 2, 
          :image => { :url => "http://example.com/lovely.gif",
            :caption => "Lovely.",
            :tag => "lovely" }}
    assert_redirected_to_login
  end
  
  def test_destroy_image
    assert_not_nil Image.find_by_id(2)

    post :destroy_image, { :id => 2 }, user_session(:admin)
    
    assert_redirected_to :action => 'list'
    assert_nil Image.find_by_id(2)
  end
  
  def test_destroy_image_fails_when_NOT_logged_in
    post :destroy_image, { :id => 2 }
    assert_redirected_to_login
  end
  
  #
  # Helpers
  #
  private
  
  def assert_image_table(image)
    id = image.id
    assert_select "form[action=/album/update_image/#{id}]" do
      assert_select "table" do
        assert_select "tr td input#image_url_#{id}[value=#{image.url}]"
        assert_select "tr td a[href=#{image.url}]", "see picture"
        assert_select "tr td", strip_textile(image.caption)
        assert_select "textarea#image_caption_#{id}", image.caption
        assert_select "tr td input#image_tags_string_#{id}[value=#{image.tags_string}]"
        assert_select "input[type=submit][value=Update]"
        assert_select "img#spinner_#{id}"
      end
    end
    assert_select "form[action=/album/destroy_image/#{id}] input[type=submit][value=Destroy]", 1
  end
  
end
