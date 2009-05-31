require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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

  describe "show a page" do
    it "should show the title, content, and an image" do
      page = mock_model(Page, :subpage? => false, :title => "the title")
      image = mock_model(Image)
      updated_at = mock("updated at time")
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)
      page.should_receive(:random_image).and_return(image)
      page.should_receive(:updated_at).and_return(updated_at)
      controller.should_receive(:render).with(:template => "pages/show")

      get :show, :id => "the identifier"

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

      response.should redirect_to("/pages")
    end
  end

  describe "edit a page" do
    it "should load up page and render edit form" do
      page = mock_model(Page)
      Page.should_receive(:find_by_identifier).with("the identifier").and_return( page)

      get :edit, { :id => "the identifier" }, user_session(:edit)

      response.should render_template("edit")
      assigns[:page].should == page
    end

    it "should redirect when not logged in" do
      get :edit, { :id => "the identifier" }

      response.should redirect_to("/users/login")
    end
  end
end

describe PagesController do
  integrate_views

  fixtures :pages, :images, :image_tags
  user_fixtures
  
  context "create action" do
    it "should display a form when logged in" do
      get :new, {}, user_session(:edit)

      assert_response :success
      assert_template "new"
      assert_select "h1", "Create Page"
      assert_page_form
    end
  
    it "should use identifier in url" do
      get :new, { :id => "identifier" }, user_session(:edit)

      assert_response :success
      response.should have_selector("input#page_identifier", :value => "identifier")
      response.should_not contain("errors prohibited this page from being saved")
    end

    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

  end
  
  context "create action" do
    context "when logged in" do
      it "should update page and model" do
        post :create,
          { :page => {
            :identifier => 'new_page', :title => 'New Page',
            :content => 'love me!'
          }
        }, user_session(:edit)

        assert_redirected_to :action => 'show', :id => 'new_page'
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
    
        post :save, :page => {
          :identifier => 'new_page', :title => 'New Page',
          :content => 'love me!'
        }

        response.should redirect_to(:controller => 'users', :action => 'login')
 
        assert_equal original_count, Page.count, "should have #{original_count} pages still"
      end
    end
  end
  
  def test_set_page_title
    xhr :post, :set_page_title,
      { :id => 1, :value => 'New Mission Statement' },
      user_session(:edit)

    assert_response :success
    assert_equal "New Mission Statement", response.body
    
    page = Page.find(1)
    assert_equal 'New Mission Statement', page.title
  end
  
  it "should redirect when setting page title" do
    xhr :post, :set_page_title, :id => 1, :value => 'New Mission Statement'
    
    response.should redirect_to(:controller => 'users', :action => 'login')
    assert_equal "Mission Statement", Page.find(1).title
  end
  
  def test_update_page_content
    xhr :post, :update_page_content,
      { :id => 1, :page => { :content => 'Mission away!' } },
      user_session(:edit)
        
    assert_response :success
    assert_select_rjs :replace_html, "page_content" do
      response.body.should match(/Mission away/)
    end
    
    page = Page.find(1)
    assert_equal 'Mission away!', page.content
  end
  
  it "should redirect updated page content" do
    xhr :get, :update_page_content,
      { :id => 1, :page => { :content => 'Mission away!' } }
    
    response.should redirect_to(:controller => 'users', :action => 'login')
    assert_equal "We state our mission.", Page.find(1).content
  end
  
  def test_set_page_identifier
    xhr :post, :set_page_identifier, { :id => 1, :value => 'mission_2'},
      user_session(:edit)
        
    assert_response :success
    assert_equal "mission_2", response.body
    
    page = Page.find(1)
    assert_equal 'mission_2', page.identifier
  end
  
  it "should redirect page identifier" do
    xhr :get, :set_page_identifier, :id => 1, :value => 'phooey'
    
    response.should redirect_to(:controller => 'users', :action => 'login')
    assert_equal "mission", Page.find(1).identifier
  end
  
  def test_destroy
    post :destroy, { :id => 1 }, user_session(:edit)
    
    assert_redirected_to :controller => 'pages', :action => 'index'

    assert_nil Page.find_by_identifier('mission')
  end
  
  def test_destroy_redirects_when_not_logged_in
    post :destroy, :id => 1
    
    response.should redirect_to(:controller => "users", :action => "login")
    
    assert_not_nil Page.find(1)
  end
  
  #
  # Helpers
  #
  private
  
  def assert_page_form
    assert_select "form[action=/pages/save]" do
      assert_select "input#page_identifier", 1
      assert_select "input#page_title", 1
      assert_select "textarea#page_content", 1
      assert_select "input[type=submit]", 1
    end
  end
  
end
