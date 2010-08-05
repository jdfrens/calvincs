require 'spec_helper'

describe PagesController, "without views" do
  user_fixtures

  describe "listing pages" do
    it "should redirect if not logged in" do
      get :index

      response.should redirect_to("/users/login")
    end

    it "should list all pages" do
      normal_pages = mock("normal pages")
      subpages = mock("subpages")
      Page.should_receive(:normal_pages).and_return(normal_pages)
      Page.should_receive(:subpages).and_return(subpages)

      get :index, {}, user_session(:edit)

      response.should be_success
      response.should render_template("pages/index")
      assigns[:normal_pages] = normal_pages
      assigns[:subpages] = subpages
    end
  end

  context "creating a new page" do
    it "should display a form when logged in" do
      get :new, {}, user_session(:edit)

      assert_response :success
      assert_template "new"
    end

    it "should redirect when not logged in" do
      get :new

      response.should redirect_to(login_path)
    end

    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(login_path)
    end
  end

  describe "show a page" do
    it "should show the title, content, and an image" do
      page = mock_model(Page, :subpage? => false, :title => "the title")
      image = mock_model(Image)
      updated_at = mock("updated at time")
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)
      page.should_receive(:random_image).and_return(image)
      page.should_receive(:updated_at).and_return(updated_at)

      get :show, :id => "the identifier"

      response.should render_template("pages/show")
      assigns[:page].should == page
      assigns[:image].should == image
      assigns[:last_updated].should == updated_at
    end

    it "should 404 if it doesn't exist" do
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(nil)

      get :show, :id => "the identifier"

      response.should render_template("errors/404")
    end

    it "should 404 if it's a subpage" do
      page = mock_model(Page, :subpage? => true)
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)

      get :show, :id => "the identifier"

      response.should render_template("errors/404")
    end

    it "should redirect to list if it doesn't exist and logged in" do
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(nil)

      get :show, { :id => "the identifier" }, user_session(:edit)

      response.should redirect_to(pages_path)
    end
  end

  describe "edit a page" do
    it "should load up page and render edit form" do
      page = mock_model(Page)
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)

      get :edit, { :id => "the identifier" }, user_session(:edit)

      response.should render_template("edit")
      assigns[:page].should == page
    end

    it "should redirect when not logged in" do
      get :edit, { :id => "the identifier" }

      response.should redirect_to("/users/login")
    end
  end

  context "update action" do
    it "should redirect when not logged in" do
      put :update, { :attribute => "the atttribute" }

      response.should redirect_to("/users/login")
    end

    it "should update a simple attribute with in-place editor" do
      page = mock_model(Page)

      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)
      page.should_receive(:update_attributes).with("title" => "new value")

      put :update, { :id => "the identifier", :attribute => "title", :value => "new value" }, user_session(:edit)

      response.should contain("new value")
    end

    it "should update the page content with JavaScript" do
      page = mock_model(Page)

      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)
      page.should_receive(:update_attributes).with("content" => "new content")

      put :update, { :id => "the identifier", :page => { :content => "new content" }, :format => "js" }, user_session(:edit)

      response.should render_template("update")
    end
  end
  
  context "destroying a page" do
    it "should destroy when logged in" do
      page = mock_model(Page)
      Page.should_receive(:find_by_identifier).with("foobar").and_return(page)
      page.should_receive(:destroy)
      
      post :destroy, { :id => "foobar" }, user_session(:edit)

      response.should redirect_to(pages_path)
    end

    it "should redirect when destroying but not logged in" do
      Page.should_not_receive(:destroy)
      
      post :destroy, :id => 1

      response.should redirect_to(login_path)
    end
  end
end

describe PagesController do
  render_views

  fixtures :pages, :images, :image_tags
  user_fixtures

  context "create action" do
    context "when logged in" do
      it "should update page and model" do
        post :create,
             { :page => {
                     :identifier => 'new_page', :title => 'New Page',
                     :content => 'love me!'
             }
             }, user_session(:edit)

        response.should redirect_to(page_path('new_page'))
        assert flash.empty?

        page = Page.find_by_identifier('new_page')
        assert_not_nil page
        assert_equal 'love me!', page.content
      end

      it "should fail with bad data" do
        original_count = Page.count

        post :create,
             { :page => { :identifier => 'bad!', :content => 'whatever' } },
             user_session(:edit)

        assert_response :success
        assert !flash.empty?
        assert_equal 'Invalid values for the page', flash[:error]

        assert_equal original_count, Page.count, "should have only four pages still"
      end
    end

    context "when NOT logged in" do
      it "should redirect and leave model alone" do
        original_count = Page.count

        post :create, :page => {
                :identifier => 'new_page', :title => 'New Page',
                :content => 'love me!'
        }

        response.should redirect_to(login_path)

        assert_equal original_count, Page.count, "should have #{original_count} pages still"
      end
    end
  end
end
