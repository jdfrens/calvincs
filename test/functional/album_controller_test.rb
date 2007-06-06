require File.dirname(__FILE__) + '/../test_helper'
require 'album_controller'

# Re-raise errors caught by the controller.
class AlbumController; def rescue_action(e) raise e end; end

class AlbumControllerTest < Test::Unit::TestCase
  
  fixtures :images
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
      assert_image_table images(:mission_statement_image)
      assert_select "div#image_form_2", 1
      assert_image_table images(:alphabet_image)
      assert_select "div#image_form_3", 1
      assert_image_table images(:mission_statement_image2)
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
  
  def test_update_image
    image = Image.find(2)
    assert_equal "http://calvin.edu/abcd.png", image.url
    assert_equal "A B C, indeed!", image.caption
    assert_equal "alphabet", image.tag
  
    xhr :post, :update_image, 
        { :id => 2,
          :image => { :url => "http://example.com/lovely.gif",
            :caption => "Lovely.",
            :tag => "lovely" }},
        user_session(:admin)

    assert_response :success
    assert_select_rjs :replace_html, "image_form_2" do
      assert_image_table({ 'id' => 2, 'url'=> "http://example.com/lovely.gif",
            'caption' => "Lovely.", 'tag' => "lovely" })
    end

    image.reload
    assert_equal "http://example.com/lovely.gif", image.url
    assert_equal "Lovely.", image.caption
    assert_equal "lovely", image.tag
  end
  
  def test_update_image_fails_when_NOT_logged_in
    xhr :post, :update_image, 
        { :id => 2, 
          :image => { :url => "http://example.com/lovely.gif",
            :caption => "Lovely.",
            :tag => "lovely" }}
    assert_redirected_to_login
  end
  
  #
  # Helpers
  #
  private
  
  def assert_image_table(image_attributes)
    id = image_attributes["id"]
    assert_select "form[action=/album/update_image/#{id}]" do
      assert_select "table" do
        assert_select "tr td input#image_url_#{id}[value=#{image_attributes['url']}]", 1
        assert_select "tr td a[href=#{image_attributes['url']}]", "see picture"
        assert_select "tr td", image_attributes['caption'].gsub('*', ''),
            "should have RedCloth-rendered caption"
        assert_select "textarea#image_caption_#{id}", image_attributes['caption']
        assert_select "input[type=submit][value=Update]"
        assert_select "tr td input#image_tag_#{id}[value=#{image_attributes['tag']}]", 1
      end
    end
      assert_select "form[action=/album/destroy/#{id}] input[type=submit][value=Destroy]", 1
  end
  
end
