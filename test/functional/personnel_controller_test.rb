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

  def test_index_redirects_to_view_all
    get :index
    
    assert_response :redirect
    assert_redirected_to :action => 'view', :id => 'all'
  end
  
  def test_list_explicit_all
    get :list, { :id => 'all' }
    
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
  
  def test_list
    get :list
    
    assert_response :success
    assert_standard_layout
    assert_select "h1#faculty", "Faculty"
    assert_select "table#faculty_listing.listing" do
      assert_entry_count "faculty"
      assert_select "tr:nth-child(1)" do
        assert_select "td a[href=/personnel/view/joel] img[src=#{images(:joel_headshot).url}]"
        assert_select "td:nth-child(2)" do
          assert_select "div.name" do
            assert_select "h2 a[href=/personnel/view/joel]", "Joel C. Adams"
            assert_select "p#joel_job_title", false, "should have no job title"
          end
          assert_select ".contact_information" do
            assert_select "p#joel_phone", false, "should have no phone"
            assert_select "p#joel_location", false, "should have no office location"
            assert_select "p#joel_email a[href=mailto:joel@calvin.foo]", "joel@calvin.foo"
            assert_select "p#joel_home_page a[href=http://www.calvin.edu/~joel]", "Home page"
          end
          assert_select "p#joel_interests", false, "should have no interests paragraph"
          assert_select "p#joel_status", false, "should have no status paragraph"
        end
      end
      assert_select "tr:nth-child(2)" do
        assert_select "td a[href=/personnel/view/jeremy] img[src=#{images(:jeremy_headshot).url}]"
        assert_select "td:nth-child(2)" do
          assert_select "div.name" do
            assert_select "h2 a[href=/personnel/view/jeremy]", "Jeremy D. Frens"
            assert_select "p#jeremy_job_title", "Assistant Professor"
          end
          assert_select ".contact_information" do
            assert_select "p#jeremy_phone", "616-526-8666"
            assert_select "p#jeremy_location", "North Hall 296"
            assert_select "p#jeremy_email a[href=mailto:jeremy@calvin.foo]", "jeremy@calvin.foo"
            assert_select "p#jeremy_home_page a[href=http://www.calvin.edu/~jeremy]", "Home page"
          end
          assert_select "p#jeremy_interests", /Interests:\s+interest 1, interest 2/
          assert_select "p#jeremy_status", "status of jeremy"
        end
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td a[href=/personnel/view/keith] img", false
        assert_select "td:nth-child(2)" do
          assert_select "div.name" do
            assert_select "h2 a[href=/personnel/view/keith]", "Keith Vander Linden"
            assert_select "p#joel_job_title", false, "should have no job title"
          end
          assert_select ".contact_information" do
            assert_select "p#keith_phone", false, "should have no phone"
            assert_select "p#keith_location", false, "should have no office location"
            assert_select "p#keith_email a[href=mailto:keith@calvin.foo]", "keith@calvin.foo"
            assert_select "p#keith_home_page a[href=http://www.calvin.edu/~keith]", "Home page"
          end
          assert_select "p#keith_interests", false, "should have no interests paragraph"
          assert_select "p#keith_status", "Keith is chair."
          end
      end
    end

    assert_select "h1#adjuncts", "Adjunct Faculty"
    assert_select "table#adjuncts_listing.listing" do
      assert_entry_count "adjuncts"
      assert_select "tr:nth-child(1)" do
        assert_select "td img", 0
        assert_select "td:nth-child(2)" do
          assert_select "h2 a[href=/personnel/view/fred]", "Fred Ferwerda"
          assert_select "p#fred_phone", false, "should have no phone"
          assert_select "p#fred_location", false, "should have no office location"
          assert_select "p#fred_interests", false
          assert_select "p#fred_status", false
        end
      end
    end

    assert_select "h1#emeriti", "Emeriti"
    assert_select "table#emeriti_listing.listing" do
      assert_entry_count "emeriti"
      # not testing details
    end

    assert_select "h1#contributors", "Contributing Faculty"
    assert_select "table#contributors_listing.listing" do
      assert_entry_count "contributors"
      # selective testing of details
      assert_select "tr:nth-child(1)" do
        assert_select "td:nth-child(2)" do
          assert_select "div.name" do
            assert_select "h2 a[href=/personnel/view/randy]", "Randy Pruim"
            assert_select "p#randy_job_title", "Professor of Mathematics and Statistics"
            assert_select "p#randy_job_title a[href=http://math.calvin.foo/]",
                "Mathematics and Statistics", "should textilize"
          end
        end
      end
    end

    assert_select "h1#staff", "Staff"
    assert_select "table#staff_listing.listing" do
      assert_entry_count "staff"
      assert_select "tr:nth-child(1)" do
        assert_select "td img[src=#{images(:sharon_headshot).url}]"
        assert_select "td:nth-child(2)" do
          assert_select "h2 a[href=/personnel/view/sharon]", "Sharon Gould"
          assert_select "p#sharon_phone", "616-526-7163"
          assert_select "p#sharon_location", "North Hall 270"
          assert_select "p#sharon_interests", false
          assert_select "p#sharon_status", "Sharon is department secretary."
        end
      end
    end

    assert_group_order
  end
  
  def test_view
    get :view, { :id => 'jeremy' }
    
    assert_response :success
    assert_standard_layout
    
    assert_select "h1", "Jeremy D. Frens"
    assert_select "p#job_title", "Assistant Professor"
    assert_select "div.img-right" do
      assert_select "img#cool-pic[src=/jeremyaction.png]"
      assert_select "p.img-caption", "jeremy in action"
    end
    assert_select "#contact_information" do
      assert_select "a[href=http://www.calvin.edu/~jeremy/]", /home page/i
      assert_select "a[href=mailto:jeremy@calvin.foo]", "jeremy@calvin.foo"
      assert_select "p", "Office phone: 616-526-8666"
      assert_select "p", "Office location: North Hall 296"
    end
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
      assert_select "a[href=/p/jeremy_interests]", false
    end
    assert_select "#status", false, "should NOT see status when NOT logged in"
    assert_select "#profile" do
      assert_select "h2", "Profile"
      assert_select "p", "profile of jeremy"
      assert_select "a[href=/p/jeremy_profile]", false
    end
  end
  
  def test_view_of_dataless_user
    get :view, { :id => 'joel' }
    
    assert_response :success
    assert_standard_layout
    
    assert_select "h1", "Joel C. Adams"
    assert_select "#contact_information" do
      assert_select "a[href=http://www.calvin.edu/~joel/]", /home page/i
      assert_select "a[href=mailto:joel@calvin.foo]", "joel@calvin.foo"
      assert_select "p", :text => /Office phone/, :count => 0
      assert_select "p", :text => /Office location/, :count => 0
    end
    assert_select "#education", false
    assert_select "#interests", false
    assert_select "#status", false
    assert_select "#profile", false
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
      assert_spinner :suffix => "name"
    end
    assert_select "p#job_title", "Assistant Professor"
    assert_select "p#job_title_edit form[onsubmit*=new Ajax.Request]" do
      assert_select "input[type=text][value=Assistant Professor]", true
      assert_select "input[type=submit]", true
      assert_spinner :suffix => "job_title"
    end
    assert_select "#contact_information" do
      assert_select "a[href=http://www.calvin.edu/~jeremy/]", /home page/i
      assert_select "a[href=mailto:jeremy@calvin.foo]", "jeremy@calvin.foo"
      assert_select "p:nth-child(2)" do
        assert_select "strong", "Office phone:"
        assert_select "input#edit_office_phone[type=button]", true
        assert_select "#user_office_phone_3_in_place_editor", "616-526-8666"
      end
      assert_select "p:nth-child(3)" do
        assert_select "strong", "Office location:"
        assert_select "input#edit_office_location[type=button]", true
        assert_select "#user_office_location_3_in_place_editor", "North Hall 296"
      end
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
      assert_select "a[href=/p/_jeremy_interests]", "view/edit interests"
    end
    assert_select "#status" do
      assert_select "h2", "Status"
      assert_select "p", "status of jeremy"
      assert_select "a[href=/p/_jeremy_status]", "view/edit status"
    end
    assert_select "#profile" do
      assert_select "h2", "Profile"
      assert_select "p", "profile of jeremy"
      assert_select "a[href=/p/_jeremy_profile]", "view/edit profile"
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
      assert_spinner :suffix => "name"
    end 
    assert_select "p#job_title", true
    assert_select "p#job_title_edit form[onsubmit*=new Ajax.Request]" do
      assert_select "input[type=text]", true
      assert_select "input[type=submit]", true
      assert_spinner :suffix => "job_title"
    end
    assert_select "#contact_information" do
      assert_select "a[href=http://www.calvin.edu/~joel/]", /home page/i
      assert_select "a[href=mailto:joel@calvin.foo]", "joel@calvin.foo"
      assert_select "p:nth-child(2)" do
        assert_select "strong", "Office phone:"
        assert_select "input#edit_office_phone[type=button]", true
        assert_select "#user_office_phone_5_in_place_editor", ""
      end
      assert_select "p:nth-child(3)" do
        assert_select "strong", "Office location:"
        assert_select "input#edit_office_location[type=button]", true
        assert_select "#user_office_location_5_in_place_editor", ""
      end
    end
    assert_select "#education" do
      assert_select "ul", true
      assert_select "div#education_edits", true
      assert_select "a[onclick*=/personnel/add_degree/5]", "Add degree"
    end
    assert_select "#interests" do
      assert_select "h2", "Interests"
      assert_select "a[href=/p/_joel_interests]", "view/edit interests"
    end
    assert_select "#status" do
      assert_select "h2", "Status"
      assert_select "a[href=/p/_joel_status]", "view/edit status"
    end
    assert_select "#profile" do
      assert_select "h2", "Profile"
      assert_select "a[href=/p/_joel_profile]", "view/edit profile"
    end
  end

  def test_view_staff_user_WHEN_logged_in
    get :view, { :id => 'sharon' }, user_session(:edit)
    
    assert_response :success
    assert_standard_layout
    
    assert_select "#education", false, "should not have any option for education"
    assert_select "#interests", false, "should not have any interests"
  end
  
  def test_view_with_invalid_username
    get :view, { :id => 'does not exist' }
    
    assert_redirected_to :action => 'list'
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
            :year => '2666'
          }
        }
        
     assert_redirected_to_login
     
     degree.reload
     assert_equal "Central College", degree.institution
  end
  
  def test_add_degree
    keith = users(:keith)
    assert_equal 1, keith.degrees.count, "should start with 1 degree"
    
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
    
    assert_equal 2, keith.degrees.count, "should have 2 degrees now"
    degree = Degree.find_by_institution("Somewhere U")
    assert_not_nil degree
    assert keith.degrees.include?(degree)
    assert_equal "BA in CS", degree.degree_type
    assert_equal 1959, degree.year
  end

  def test_add_degree_fails_when_NOT_logged_in
    keith = users(:keith)
    assert_equal 1, keith.degrees.count, "should start with 1 degree"
    
    xhr :post, :add_degree, { :id => keith.id }
    
    assert_redirected_to_login
    assert_equal 1, keith.degrees.count, "should still have 1 degrees"
  end
  
  def test_set_user_office_phone
    keith = users(:keith)
    assert_nil keith.office_phone
    
    xhr :post, :set_user_office_phone,
        { :id => keith.id, :value => '616-111-9999' },
        user_session(:edit)
    
    assert_response :success
    keith.reload
    assert_equal '616-111-9999', keith.office_phone
  end
  
  def test_set_user_office_phone_redirects_when_NOT_logged_in
    keith = users(:keith)
    assert_nil keith.office_phone
    
    xhr :post, :set_user_office_phone,
        { :id => keith.id, :value => '616-111-9999' }
        
    assert_redirected_to_login
    keith.reload
    assert_nil keith.office_phone
  end
  
  def test_set_user_office_location
    keith = users(:keith)
    assert_nil keith.office_location
    
    xhr :post, :set_user_office_location,
        { :id => keith.id, :value => 'Funkytown' },
        user_session(:edit)
    
    assert_response :success
    keith.reload
    assert_equal 'Funkytown', keith.office_location
  end
  
  def test_set_user_office_location_redirects_when_NOT_logged_in
    keith = users(:keith)
    assert_nil keith.office_location
    
    xhr :post, :set_user_office_location,
        { :id => keith.id, :value => 'Funkytown' }
        
    assert_redirected_to_login
    keith.reload
    assert_nil keith.office_location
  end
  
  def test_update_job_title
    keith = users(:keith)
    assert_nil keith.job_title
    
    xhr :post, :update_job_title,
        { :id => keith.id, :user => { :job_title => 'Professional *Sidekick*' } },
        user_session(:edit)
        
    assert_response :success
    assert_select_rjs :replace_html, "job_title" do
      assert_match(/Professional <strong>Sidekick<\/strong>/, @response.body)
    end
    keith.reload
    assert_equal 'Professional *Sidekick*', keith.job_title
  end
  
  def test_update_job_title_redirects_when_NOT_logged_in
    keith = users(:keith)
    assert_nil keith.job_title
    
    xhr :post, :update_job_title,
        { :id => keith.id, :value => 'Professional Sidekick' }
        
    assert_redirected_to_login
    keith.reload
    assert_nil keith.job_title
  end
  
  #
  # Helpers
  #
  private
  
  def assert_entry_count(name)
    assert_select "tr", Group.find_by_name(name).users.count,
        "should have one row per #{name}"
  end
  
  def assert_group_order
    assert_select "h1#faculty ~ h1#adjuncts", true
    assert_select "h1#adjuncts ~ h1#emeriti", true
    assert_select "h1#emeriti ~ h1#contributors", true
    assert_select "h1#contributors ~ h1#staff", true
  end
  
end
