require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AlbumController do
  integrate_views
  
  fixtures :images, :image_tags
  user_fixtures
  
  context "list action" do
    it "should redirect when not logged in" do
      get :list

      response.should redirect_to(:controller => 'users', :action => 'login')
    end


    context "when logged in" do
      it "should list image forms" do
        get :list, {}, user_session(:edit)
    
        assert_response :success
        assert_select "h1", "List of Images"
        assert_select "div#image-list" do
          assert_select "table", Image.count, "should be one table per image"
          assert_select "div#image-form-1"
          assert_image_table images(:mission_wide)
          assert_select "div#image-form-2"
          assert_image_table images(:alphabet)
          assert_select "div#image-form-3"
          assert_image_table images(:mission_narrow)
          # assuming other images are okay...
        end
      end
    end  
  end
  
  context "create action" do
    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(:controller => 'users', :action => 'login')
    end


    context "when logged in" do
      it "should see a form" do
        get :create, {}, user_session(:edit)
    
        assert_response :success
        assert_select "form[action=/album/create]" do
          assert_select "input#image_url"
          assert_select "textarea#image_caption"
          assert_select "input#image_tags_string"
          assert_select "input#image_tags_string[value*=]", false,
            "should not have a value for the tags string"
          assert_select "input[type=submit]"
        end
      end
  
      it "should create a new image" do
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
    end  
  end
  
  context "update action" do
    it "should redirect when not logged in" do
      post :update_image

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

    
    context "when logged in" do
      it "should update image" do
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
        assert_select_rjs :replace_html, "image-form-2" do
          assert_image_table image
        end
      end
    end
  end
   
  context "destroy action" do
    it "should redirect when not logged in" do
      get :destroy_image

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

    
    context "when logged in" do
      it "should destroy image" do
        
        assert_not_nil Image.find_by_id(2)

        post :destroy_image, { :id => 2 }, user_session(:edit)
    
        assert_redirected_to :action => 'list'
        assert_nil Image.find_by_id(2)
      end
    end
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
        assert_select "tr td", image.caption
        assert_select "textarea#image_caption_#{id}", image.caption
        assert_select "tr td input#image_tags_string_#{id}[value=#{image.tags_string}]"
        assert_select "input[type=submit][value=Update]"
        assert_spinner :number => id
      end
    end
    assert_select "form[action=/album/destroy_image/#{id}] input[type=submit][value=Destroy]", 1
  end
  
end
