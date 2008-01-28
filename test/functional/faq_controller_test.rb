require File.dirname(__FILE__) + '/../test_helper'
require 'faq_controller'

# Re-raise errors caught by the controller.
class FaqController; def rescue_action(e) raise e end; end

class FaqControllerTest < Test::Unit::TestCase
  
  fixtures :faqs, :questions
  user_fixtures
  
  def setup
    @controller = FaqController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "index action" do
    should "redirect to list" do
      get :index
      assert_redirected_to :action => :list
    end    
  end

  context "create FAQ action" do
    should_redirect_to_login_when_NOT_logged_in :create
  
    context "when logged in" do
      should "see a form" do
        get :create, {}, user_session(:edit)
    
        assert_response :success
        assert_standard_layout
    
        assert_select "form[action=/faq/create]" do
          assert_select "input#faq_title", true
          assert_select "input#faq_identifier", true
          assert_select "input[type=submit]", true
        end
      end
    
      should "create a new FAQ" do
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
  
      should "fail to create a new FAQ on bad data" do
        post :create,
          { :faq => {
            :title => "",
            :identifier => "faq identifier"} },
          user_session(:edit)
        
        assert_response :success
        assert_standard_layout
        assert_select "div#errorExplanation" do
          assert_select "li", /title/i, "title should be bad"
          assert_select "li", /identifier/i, "identifier should be bad"
        end
        assert_select "form[action=/faq/create]"
      end
    end
  end
end
