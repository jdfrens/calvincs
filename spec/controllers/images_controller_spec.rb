require 'spec_helper'

describe ImagesController do
  fixtures :images, :image_tags
  user_fixtures

  context "GET index" do
    it "should redirect when not logged in" do
      get :index

      response.should redirect_to(login_path)
    end

    it "should list image forms" do
      images = mock("images")
      Image.should_receive(:includes).with(:image_tags).and_return(images)

      get :index, {}, user_session(:edit)

      assert_response :success
      assigns[:images].should == images
    end
  end

  context "create action" do
    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(login_path)
    end


    context "when logged in" do
      it "should see a form" do
        get :new, {}, user_session(:edit)

        assert_response :success
      end

      it "should create a new image" do
        image = mock_model(Image)
        image_params = { "url" => "some url", "tags_string" => "string of tags" }

        Image.should_receive(:create!).with(image_params).and_return(image)
        image.should_receive(:tags_string=).with("string of tags")
        image.should_receive(:save!)

        get :create, { :image => image_params }, user_session(:edit)

        response.should redirect_to(images_path)
      end
    end
  end

  context "edit action" do
    it "should redirect when not logged in" do
      get :edit

      response.should redirect_to(login_path)
    end

    it "should find image and render view" do
      image = mock_model(Image)

      Image.should_receive(:find).with(image.id).and_return(image)

      get :edit, { :id => image.id }, user_session(:edit)

      assigns[:image].should == image
      response.should render_template("images/edit")
    end
  end

  context "update action" do
    it "should redirect when not logged in" do
      post :update

      response.should redirect_to(login_path)
    end

    context "when logged in" do
      it "should update image" do
        image = mock_model(Image)
        image_params = { "stuff" => "generic", "tags_string" => "one two three" }

        Image.should_receive(:find).with(image.id).and_return(image)
        image.should_receive(:update_attributes).with(image_params)
        image.should_receive(:tags_string=).with("one two three")
        image.should_receive(:save!).and_return(true)

        post :update, { :id => image.id, :image => image_params }, user_session(:edit)

        response.should redirect_to(images_path)
      end
    end
  end

  context "destroy action" do
    it "should redirect when not logged in" do
      get :destroy

      response.should redirect_to(login_path)
    end


    context "when logged in" do
      it "should destroy image" do
        image = mock_model(Image)

        Image.should_receive(:find).with(123).and_return(image)
        image.should_receive(:destroy)

        post :destroy, { :id => 123 }, user_session(:edit)

        response.should redirect_to(images_path)
      end
    end
  end

  context "refresh dimensions" do
    it "should redirect when not logged in" do
      get :refresh

      response.should redirect_to(login_path)
    end

    it "should refresh dimensions" do
      Image.should_receive(:refresh_dimensions!)
      
      get :refresh, {}, user_session(:edit)

      response.should redirect_to(images_path)
    end
  end

end
