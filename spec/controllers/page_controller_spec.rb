require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PageController, "without views" do
  user_fixtures

  describe "view a page" do
    it "should show the title, content, and an image" do
      page = mock_model(Page, :subpage? => false, :title => "the title")
      image = mock_model(Image)
      updated_at = mock("updated at time")
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)
      page.should_receive(:random_image).and_return(image)
      page.should_receive(:updated_at).and_return(updated_at)

      get :view, :id => "the identifier"

      response.should render_template("view")
      assigns[:page].should == page
      assigns[:image].should == image
      assigns[:last_updated].should == updated_at
    end

    it "should 404 if it doesn't exist" do
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(nil)

      get :view, :id => "the identifier"

      response.should render_template("errors/404")
    end

    it "should 404 if it's a subpage" do
      page = mock_model(Page, :subpage? => true)
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(page)

      get :view, :id => "the identifier"

      response.should render_template("errors/404")
    end

    it "should redirect to list if it doesn't exist and logged in" do
      Page.should_receive(:find_by_identifier).with("the identifier").and_return(nil)

      get :view, { :id => "the identifier" }, user_session(:edit)

      response.should redirect_to("/page/list")
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

describe PageController do
  integrate_views

  fixtures :pages, :images, :image_tags
  user_fixtures
  
  context "index action" do
    it "should redirect to the list action" do
      get :index
      assert_redirected_to :controller => 'page', :action => 'list'
    end
  end
  
  context "create action" do
    it "should display a form when logged in" do
      get :create, {}, user_session(:edit)

      assert_response :success
      assert_template "page/create"
      assert_select "h1", "Create Page"
      assert_page_form
    end
  
    it "should use identifier in url" do
      get :create, { :id => "identifier" }, user_session(:edit)

      assert_response :success
      response.should have_selector("input#page_identifier", :value => "identifier")
      response.should_not contain("errors prohibited this page from being saved")
    end

    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

  end
  
  context "list action" do
    it "should display a table of pages when logged in" do
      get :list, {}, user_session(:edit), { :error => 'Error flash!' }
    
      assert_response :success
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
  
    it "should redirect when not logged in" do
      get :list

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

  end
   
  context "save action" do
    context "when logged in" do
      it "should update page and model" do
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

      it "should fail with bad data" do
        original_count = Page.count
    
        post :save,
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
    
    assert_redirected_to :controller => 'page', :action => 'list'

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
  
  def assert_standard_page_entries
    assert_page_entry pages(:alphabet)
    assert_page_entry pages(:mission)
    assert_page_entry pages(:home_page)
    assert_page_entry pages(:home_splash)
    assert_page_entries_order
  end

  def assert_page_entries_order
    names = [:home_page, :home_splash, :alphabet, :mission]
    current_page = pages(names.shift)
    names.each do |next_identifier|
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
