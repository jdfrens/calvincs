require File.dirname(__FILE__) + '/../test_helper'
require 'curriculum_controller'

# Re-raise errors caught by the controller.
class CurriculumController; def rescue_action(e) raise e end; end

class CurriculumControllerTest < Test::Unit::TestCase
  def setup
    @controller = CurriculumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
