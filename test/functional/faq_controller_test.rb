require File.dirname(__FILE__) + '/../test_helper'
require 'faq_controller'

# Re-raise errors caught by the controller.
class FaqController; def rescue_action(e) raise e end; end

class FaqControllerTest < Test::Unit::TestCase
  
  fixtures :faqs, :questions
  
  def setup
    @controller = FaqController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_redirects_to_list
    get :index
    assert_redirected_to :action => :list
  end
end
