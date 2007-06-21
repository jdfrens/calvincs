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
        assert_select "td:nth-child(2)" do
          assert_select "h2", "Joel C. Adams"
          assert_select "ul"
        end
      end
      assert_select "tr:nth-child(2)" do
        assert_select "td img[src=#{images(:jeremy_faculty).url}]"
        assert_select "td:nth-child(2)" do
          assert_select "h2", "Jeremy D. Frens"
          assert_select "ul" do
#            assert_select "li", "B.A. in CS and MATH, Calvin College, 1992"
#            assert_select "li a[href=http://cs.calvin.edu/]", "Calvin College"
#            assert_select "li", "M.S. in CS, Indiana University, 1994"
#            assert_select "li", "Ph.D. in CS, Indiana University, 2002"
#            assert_select "li a[href=http://cs.indiana.edu/]", "Indiana University"
          end
        end
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td img", false
        assert_select "td:nth-child(2)" do
          assert_select "h2", "Keith Vander Linden"
          assert_select "ul" do
#            assert_select "li", "B.A. in CS and MATH, Central College, 1983"
          end
        end
      end
    end
  end
  
  def test_view
    get :view, { :id => 'jeremy' }
    
    assert_response :success
    assert_standard_layout
    
    assert_select "h1", "Jeremy D. Frens"
  end
  
  def test_view_WHEN_logged_in
    get :view, { :id => 'jeremy' }, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    
    assert_select "div#full_name_header h1", "Jeremy D. Frens"
    assert_select "form" do
      assert_select "input[value=Jeremy D.]"
      assert_select "input[value=Frens]"
      assert_select "input[type=submit]"
    end
  end
  
  def test_view_with_invalid_username
    get :view, { :id => 'does not exist' }
    
    assert_redirected_to :action => 'faculty'
  end
  
  def test_update_name
    keith = users(:keith)
    assert_equal "Keith Vander Linden", keith.full_name

    xhr :post, :update_name,
        { :id => keith.id,
          :user => { :first_name => 'a', :last_name => 'b'}
        }, user_session(:edit)
        
    assert_response :success
    assert_select_rjs :replace_html, "full_name_header" do
      assert_select "h1", "a b"
    end
    
    keith.reload
    assert_equal "a b", keith.full_name
  end

  def test_update_name_when_NOT_logged_in
    keith = users(:keith)
    assert_equal "Keith Vander Linden", keith.full_name

    xhr :post, :update_name,
        { :id => keith.id,
          :user => { :first_name => 'a', :last_name => 'b'}
        }
        
    assert_redirected_to_login
    
    keith.reload
    assert_equal "Keith Vander Linden", keith.full_name
  end
  
end
