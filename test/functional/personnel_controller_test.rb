require File.dirname(__FILE__) + '/../test_helper'
require 'personnel_controller'

# Re-raise errors caught by the controller.
class PersonnelController; def rescue_action(e) raise e end; end

class PersonnelControllerTest < Test::Unit::TestCase

  fixtures :images, :image_tags
  user_fixtures

  def setup
    @controller = PersonnelController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_redirects_to_faculty
    get :index
    
    assert_response :redirect
    assert_redirected_to :action => 'faculty'
  end
  
  def test_faculty
    get :faculty
    
    assert_response :success
    assert_standard_layout
    assert_select "table" do
      assert_select "tr", 3, "should have three faculty"
      assert_select "tr:nth-child(1)" do
        assert_select "td img[src=#{images(:joel_faculty).url}]"
        assert_select "td h2", "Joel C. Adams"
      end
      assert_select "tr:nth-child(2)" do
        assert_select "td img[src=#{images(:jeremy_faculty).url}]"
        assert_select "td h2", "Jeremy D. Frens"
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td img", false
        assert_select "td h2", "Keith Vander Linden"
      end
    end
  end
  
end
