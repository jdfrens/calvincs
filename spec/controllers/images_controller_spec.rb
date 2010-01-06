require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImagesController do
  fixtures :images, :image_tags
  user_fixtures

  context "list action" do
    it "should redirect when not logged in" do
      get :list

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

    it "should list image forms" do
      images = mock("images")
      Image.should_receive(:find).with(:all, :include => [:image_tags]).and_return(images)

      get :index, {}, user_session(:edit)

      assert_response :success
      assigns[:images].should == images
    end
  end

  context "create action" do
    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(:controller => 'users', :action => 'login')
    end


    context "when logged in" do
      it "should see a form" do
        get :new, {}, user_session(:edit)

        assert_response :success
      end

      it "should create a new image" do
        ImageInfo.fake_size("http://example.com/foo.gif", :width => 265, :height => 200)

        get :create,
                { :image => {
                        :url => "http://example.com/foo.gif",
                        :caption => "Foo is bar!",
                        :tags_string => "foobar barfoo" } },
                user_session(:edit)

        assert_redirected_to :action => 'index'
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
      post :update

      response.should redirect_to(:controller => 'users', :action => 'login')
    end


    context "when logged in" do
      it "should update image" do
        ImageInfo.fake_size("http://example.com/lovely.gif", :width => 199, :height => 265)

        image = Image.find(2)
        assert_equal "http://calvin.edu/abcd.png", image.url
        assert_equal "A B C, indeed!", image.caption
        assert_equal "", image.tags_string

        post :update,
                { :format => "js", :id => 2,
                        :image => {
                                :url => "http://example.com/lovely.gif",
                                :caption => "Lovely.",
                                :tags_string => "very lovely" } },
                user_session(:edit)

        assert_response :success
        
        image.reload
        assert_equal "http://example.com/lovely.gif", image.url
        assert_equal "Lovely.", image.caption
        assert_equal 199, image.width
        assert_equal 265, image.height
        assert_equal "very lovely", image.tags_string
      end
    end
  end

  context "destroy action" do
    it "should redirect when not logged in" do
      get :destroy

      response.should redirect_to(:controller => 'users', :action => 'login')
    end


    context "when logged in" do
      it "should destroy image" do

        assert_not_nil Image.find_by_id(2)

        post :destroy, { :id => 2 }, user_session(:edit)

        assert_redirected_to :action => 'index'
        assert_nil Image.find_by_id(2)
      end
    end
  end

end
