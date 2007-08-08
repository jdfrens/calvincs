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
    get :list, {}, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    assert_select "h1", "List of Images"
    assert_select "div#image_list" do
      assert_select "table", Image.count, "should be one table per image"
      assert_select "div#image_form_1"
      assert_image_table images(:mission_wide)
      assert_select "div#image_form_2"
      assert_image_table images(:alphabet)
      assert_select "div#image_form_3"
      assert_image_table images(:mission_narrow)
      # assuming other images are okay...
    end
  end
  
  def test_list_redirects_when_NOT_logged_in
    get :list
    assert_redirected_to_login
  end
  
  def test_new_image_form
    get :create, {}, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    assert_select "form[action=/album/create]" do
      assert_select "input#image_url"
      assert_select "textarea#image_caption"
      assert_select "input#image_tags_string"
      assert_select "input#image_tags_string[value*=]", false,
          "should not have a value for the tags string"
      assert_select "input[type=submit]"
    end
  end
  
  def test_new_image_creation
    ImageInfo.fake_size("http://example.com/foo.gif", :width => 265, :height => 200)

    get :create,
        { :image => {
            :url => "http://example.com/foo.gif",
            :caption => "Foo is bar!",
            :tags_string => "foobar barfoo" } },
        user_session(:edit)
    
    assert_redirected_to :action => 'list'
    image = Image.find_by_caption("Foo is bar!")
    
    assert_not_nil image
    assert_equal "http://example.com/foo.gif", image.url
    assert_equal 265, image.width
    assert_equal 200, image.height
    assert_equal "Foo is bar!", image.caption
    assert_equal ["foobar", "barfoo"], image.tags
  end
  
  def test_new_image_form_redirects_when_NOT_logged_in
    original_image_count = Image.count
    original_tag_count = ImageTag.count
    
    get :create,
        { :image => {
            :url => "http://example.com/foo.gif",
            :caption => "Foo is bar!",
            :tags_string => "foo bar" }}
    
    assert_redirected_to_login
    assert_equal original_image_count, Image.count, "shouldn't add new image"
    assert_equal original_tag_count, ImageTag.count, "shouldn't add new image tags"
  end
  
  def test_update_image
    ImageInfo.fake_size("http://example.com/lovely.gif", :width => 199, :height => 265)

    image = Image.find(2)
    assert_equal "http://calvin.edu/abcd.png", image.url
    assert_equal "A B C, indeed!", image.caption
    assert_equal "", image.tags_string
  
    xhr :post, :update_image, 
        { :id => 2,
          :image => {
            :url => "http://example.com/lovely.gif",
            :caption => "Lovely.",
            :tags_string => "very lovely" } },
        user_session(:edit)

    image.reload
    assert_equal "http://example.com/lovely.gif", image.url
    assert_equal "Lovely.", image.caption
    assert_equal 199, image.width
    assert_equal 265, image.height
    assert_equal "very lovely", image.tags_string

    assert_response :success
    assert_select_rjs :replace_html, "image_form_2" do
      assert_image_table image
    end
  end
  
  def test_update_image_fails_when_NOT_logged_in
    xhr :post, :update_image, 
        { :id => 2, 
          :image => {
            :url => "http://example.com/lovely.gif",
            :caption => "Lovely.",
            :tags_string => "lovely" }}
    assert_redirected_to_login
  end
  
  def test_destroy_image
    assert_not_nil Image.find_by_id(2)

    post :destroy_image, { :id => 2 }, user_session(:edit)
    
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
        assert_select "tr td .dimension", "#{image.width}x#{image.height}"
        assert_select "tr td .usability", image.usability.to_s
        assert_select "tr td", strip_textile(image.caption)
        assert_select "textarea#image_caption_#{id}", image.caption
        assert_select "tr td input#image_tags_string_#{id}[value=#{image.tags_string}]"
        assert_select "input[type=submit][value=Update]"
        assert_spinner :number => id
      end
    end
    assert_select "form[action=/album/destroy_image/#{id}] input[type=submit][value=Destroy]", 1
  end
  
end
