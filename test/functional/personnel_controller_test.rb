require File.dirname(__FILE__) + '/../test_helper'
require 'personnel_controller'

# Re-raise errors caught by the controller.
class PersonnelController; def rescue_action(e) raise e end; end

class PersonnelControllerTest < Test::Unit::TestCase

  fixtures :images, :image_tags, :degrees
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
    assert_select "h1", "Faculty"
    assert_select "table#faculty_listing" do
      assert_select "tr", 3, "should have three faculty"
      assert_select "tr:nth-child(1)" do
        assert_select "td img[src=#{images(:joel_faculty).url}]"
        assert_select "td:nth-child(2)" do
          assert_select "h2 a[href=/personnel/view/joel]", "Joel C. Adams"
          assert_select "ul"
        end
      end
      assert_select "tr:nth-child(2)" do
        assert_select "td img[src=#{images(:jeremy_faculty).url}]"
        assert_select "td:nth-child(2)" do
          assert_select "h2 a[href=/personnel/view/jeremy]", "Jeremy D. Frens"
          assert_select "ul" do
            assert_select "li", "B.A. in CS and MATH, Calvin College, 1992"
            assert_select "li a[href=http://cs.calvin.edu/]", "Calvin College"
            assert_select "li", "Ph.D. in CS, Indiana University, 2002"
            assert_select "li a[href=http://cs.indiana.edu/]", "Indiana University"
          end
        end
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td img", false
        assert_select "td:nth-child(2)" do
          assert_select "h2 a[href=/personnel/view/keith]", "Keith Vander Linden"
          assert_select "ul" do
            assert_select "li", "B.A. in CS and MATH, Central College, 1983"
            assert_select "li a", false, "keith should have no institution URL"
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
    assert_select "#education" do
      assert_select "h2", "Education"
      assert_select "ul" do
        assert_select "li", 2, "should have two degrees"
        assert_select "div#degree_1 li", "B.A. in CS and MATH, Calvin College, 1992"
        assert_select "div#degree_3 li", "Ph.D. in CS, Indiana University, 2002"
      end
    end
    assert_select "#interests" do
      assert_select "h2", "Interests"
      assert_select "p", "interest 1, interest 2"
    end
  end
  
  def test_view_of_dataless_user
    get :view, { :id => 'joel' }
    
    assert_response :success
    assert_standard_layout
    
    assert_select "h1", "Joel C. Adams"
    assert_select "#education", false
    assert_select "#interests", false
  end
  
  def test_view_WHEN_logged_in
    get :view, { :id => 'jeremy' }, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    
    assert_select "div#full_name_header h1", "Jeremy D. Frens"
    assert_remote_form_for_and_spinner("full_name_edit", "/personnel/update_name/3")
    assert_select "form" do
      assert_select "input[value=Jeremy D.]"
      assert_select "input[value=Frens]"
      assert_select "input[type=submit]"
      assert_spinner
    end
    assert_select "#education" do
      assert_select "ul" do
        assert_select "li", 2, "should have two degrees"
        assert_select "div#degree_1 li", "B.A. in CS and MATH, Calvin College, 1992"
        assert_select "div#degree_3 li", "Ph.D. in CS, Indiana University, 2002"
      end
      assert_select "div#education_edits" do
        assert_remote_form_for_and_spinner("degree_edit_1", "/personnel/update_degree/1")
        assert_select "form#degree_edit_1" do
          assert_select "input[type=text][value=B.A. in CS and MATH]"
          assert_select "input[type=text][value=Calvin College]"
          assert_select "input[type=text][value=http://cs.calvin.edu/]"
          assert_select "input[type=text][value=1992]"
          assert_select "input[type=submit]"
          assert_spinner :number => 1
        end
        assert_remote_form_for_and_spinner("degree_edit_3", "/personnel/update_degree/3")
        assert_select "form#degree_edit_3" do
          assert_select "input[type=text][value=Ph.D. in CS]"
          assert_select "input[type=text][value=Indiana University]"
          assert_select "input[type=text][value=http://cs.indiana.edu/]"
          assert_select "input[type=text][value=2002]"
          assert_select "input[type=submit]"
          assert_spinner :number => 3
        end
      end
      assert_select "a[onclick*=/personnel/add_degree/3]", "Add degree"
    end
    assert_select "#interests" do
      assert_select "h2", "Interests"
      assert_select "p", "interest 1, interest 2"
      assert_select "a[href=/p/jeremy_interests]"
    end
  end

  def test_view_dataless_user_WHEN_logged_in
    get :view, { :id => 'joel' }, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    
    assert_select "div#full_name_header h1", "Joel C. Adams"
    assert_remote_form_for_and_spinner("full_name_edit", "/personnel/update_name/5")
    assert_select "form" do
      assert_select "input[value=Joel C.]"
      assert_select "input[value=Adams]"
      assert_select "input[type=submit]"
      assert_spinner
    end
    assert_select "#education" do
      assert_select "ul", true
      assert_select "div#education_edits", true
      assert_select "a[onclick*=/personnel/add_degree/5]", "Add degree"
    end
    assert_select "#interests" do
      assert_select "h2", "Interests"
      assert_select "a[href=/p/joel_interests]", "view/edit interests"
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
  
  def test_update_degree
    degree = degrees(:keith_central)
    
    xhr :post, :update_degree,
        { :id => degree.id,
          :degree => {
            :degree_type => 'BS',
            :institution => 'Nowhere',
            :url => 'foo',
            :year => '1666'
          }
        }, user_session(:edit)
        
     assert_response :success
     assert_select_rjs :replace_html, "degree_#{degree.id}" do
       assert_select "li", "BS, Nowhere, 1666"
     end
     
     degree.reload
     assert_equal "BS", degree.degree_type
     assert_equal "Nowhere", degree.institution
     assert_equal "foo", degree.url
     assert_equal 1666, degree.year
  end

  def test_update_degree_fails_when_NOT_logged_in
    degree = degrees(:keith_central)
    
    xhr :post, :update_degree,
        { :id => degree.id,
          :degree => {
            :degree_type => 'BS',
            :institution => 'Nowhere',
            :url => 'foo',
            :year => '1666'
          }
        }
        
     assert_redirected_to_login
     
     degree.reload
     assert_equal "Central College", degree.institution
  end
  
  def test_add_degree
    keith = users(:keith)
    assert_equal 1, keith.degrees.size, "should start with 1 degree"
    
    xhr :post, :add_degree, { :id => keith.id }, user_session(:edit)
        
    assert_response :success
    assert_select_rjs :insert, :bottom, "education" do
      assert_select "li", "BA in CS, Somewhere U, 1959"
    end
    assert_select_rjs :insert, :bottom, "education_edits" do
      assert_select "form" do
        assert_select "input[type=text]", 4
        assert_select "input[value=BA in CS]"
        assert_select "input[value=Somewhere U]"
        assert_select "input[value=1959]"
      end
    end
    
    assert_equal 2, keith.degrees.size, "should have 2 degrees now"
    degree = Degree.find_by_institution("Somewhere U")
    assert_not_nil degree
    assert keith.degrees.include?(degree)
    assert_equal "BA in CS", degree.degree_type
    assert_equal 1959, degree.year
  end

  def test_add_degree_fails_when_NOT_logged_in
    keith = users(:keith)
    assert_equal 1, keith.degrees.size, "should start with 1 degree"
    
    xhr :post, :add_degree, { :id => keith.id }
    
    assert_redirected_to_login
    assert_equal 1, keith.degrees.size, "should still have 1 degrees"
  end
  
end
