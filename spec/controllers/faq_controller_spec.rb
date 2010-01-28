require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FaqController do
  integrate_views

  fixtures :faqs, :questions
  user_fixtures

  context "index action" do
    it "should redirect to list" do
      get :index
      assert_redirected_to :action => :list
    end    
  end

  describe "create FAQ action" do
    it "should redirect when not logged in" do
      get :create

      response.should redirect_to(login_path)
    end

  
    context "when logged in" do
      it "should see a form" do
        get :create, {}, user_session(:edit)
    
        assert_response :success
    
        assert_select "form[action=/faq/create]" do
          assert_select "input#faq_title", true
          assert_select "input#faq_identifier", true
          assert_select "input[type=submit]", true
        end
      end
    
      it "should create a new FAQ" do
        post :create,
          { :faq => {
            :title => "FAQ Title",
            :identifier => "faq_identifier"} },
          user_session(:edit)
        
        assert_redirected_to :action => :view, :id => "faq_identifier"
    
        faq = Faq.find_by_identifier("faq_identifier")
        assert_not_nil faq
        assert_equal "FAQ Title", faq.title
      end
  
      it "should fail to create a new FAQ on bad data" do
        post :create,
          { :faq => {
            :title => "",
            :identifier => "faq identifier"} },
          user_session(:edit)
        
        assert_response :success
        assert_select "div#errorExplanation" do
          assert_select "li", /title/i, "title should be bad"
          assert_select "li", /identifier/i, "identifier should be bad"
        end
        assert_select "form[action=/faq/create]"
      end
    end
  end
end
