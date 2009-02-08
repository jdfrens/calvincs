require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonnelController do
  integrate_views
  
  fixtures :images, :image_tags, :degrees, :pages
  user_fixtures
  
  context "index action" do
    it "should redirect to viewing all" do
      get :index
    
      assert_response :redirect
      assert_redirected_to :action => 'view', :id => 'all'      
    end
  end

  context "list action" do
    it "should redirect for an explicit 'all' id" do
      get :list, { :id => 'all' }
    
      assert_response :redirect
      assert_redirected_to :action => 'list'
    end

    context "done normally" do
      it "should set the proper data" do
        get :list
      
        assert_response :success
        assert_equal users(:sharon).updated_at, assigns(:last_updated)
        assert_equal [users(:joel), users(:jeremy), users(:keith)], assigns(:faculty)
        assert_equal [users(:fred)], assigns(:adjuncts)
        assert_equal [users(:randy)], assigns(:contributors)
        assert_equal [users(:larry)], assigns(:emeriti)
        assert_equal [users(:sharon)], assigns(:staff)
      end
    
      it "should use the standard layout" do
        get :list
      
        assert_response :success
        assigns[:title].should == "Faculty & Staff"
        assigns[:last_updated].should == users(:sharon).updated_at
      end
    
      it "should see personel in a particular order" do
        get :list
    
        assert_response :success
        assert_select "#faculty ~ #adjuncts", true
        assert_select "#adjuncts ~ #emeriti", true
        assert_select "#emeriti ~ #contributors", true
        assert_select "#contributors ~ #staff", true
      end

      it "should have proper headers" do
        get :list
    
        assert_response :success
        assert_select "h1#faculty", "Faculty"
        assert_select "h1#adjuncts", "Adjunct Faculty"
        assert_select "h1#emeriti", "Emeriti"
        assert_select "h1#contributors", "Contributing Faculty"
        assert_select "h1#staff", "Staff"
      end
    
      it "should see dataless faculty" do
        get :list
    
        assert_response :success
        assert_select "table#faculty_listing.listing" do
          assert_select "tr:nth-child(1)" do
            assert_select "td a[href=/personnel/view/joel] img[src=#{images(:joel_headshot).url}]"
            assert_select "td:nth-child(2)" do
              assert_select "div.name" do
                assert_select "h2 a[href=/personnel/view/joel]", "Joel C. Adams"
                assert_select "p#joel_job_title", false, "should have no job title"
              end
              assert_select ".contact-information" do
                assert_select "p#joel_phone", false, "should have no phone"
                assert_select "p#joel_location", false, "should have no office location"
                assert_select "p#joel_email a[href=mailto:joel@calvin.foo]", "joel@calvin.foo"
              end
              assert_select "p#joel_interests", false, "should have no interests paragraph"
              assert_select "p#joel_status", false, "should have no status paragraph"
            end
          end
        end
      end
  
      it "should see dataful faculty" do
        get :list
    
        assert_response :success
        assert_select "tr:nth-child(2)" do
          assert_select "td a[href=/personnel/view/jeremy] img[src=#{images(:jeremy_headshot).url}]"
          assert_select "td:nth-child(2)" do
            assert_select "div.name" do
              assert_select "h2 a[href=/personnel/view/jeremy]", "Jeremy D. Frens"
              assert_select "p#jeremy_job_title", "Assistant Professor"
            end
            assert_select ".contact-information" do
              assert_select "p#jeremy_phone", "616-526-8666"
              assert_select "p#jeremy_location", "North Hall 296"
              assert_select "p#jeremy_email a[href=mailto:jeremy@calvin.foo]", "jeremy@calvin.foo"
            end
            assert_select "p#jeremy_interests", /Interests:\s+interest 1, interest 2/
            assert_select "p", "status of jeremy"
          end
        end
      end   
  
      it "should see adjuncts" do
        get :list
        assert_personnel_briefly "adjuncts", "fred", "Fred Ferwerda"
      end   
  
      it "should see emeriti" do
        get :list
        assert_personnel_briefly "emeriti", "larry", "Larry Nyhoff"
      end   
  
      it "should see contributing faculty" do
        get :list
        assert_personnel_briefly "contributors", "randy", "Randy Pruim"
      end   
  
      it "should see staff" do
        get :list
        assert_personnel_briefly "staff", "sharon", "Sharon Gould"
      end
    end
  
    it "should use date of last updated" do
      user = users(:jeremy)
      user.first_name = "bob"
      user.save!
    
      get :list
    
      assert_response :success
      user.reload
      assert_equal user.updated_at, assigns(:last_updated)
    end
  end

  context "view action" do
    context "when NOT logged in" do
      it "should see dataful user" do
        get :view, { :id => 'jeremy' }
    
        assert_response :success
        assert_equal users(:jeremy).last_updated_dates.max, assigns(:last_updated)
        assert_equal "Jeremy D. Frens", assigns(:title)
        assigns[:title].should == "Jeremy D. Frens"
        assigns[:last_updated].should == users(:jeremy).last_updated_dates.max
    
        assert_select "h1", "Jeremy D. Frens"
        assert_select "p#job_title", "Assistant Professor"
        assert_select "div.img-right-unusable" do
          assert_select "img#cool-pic[src=/jeremyaction.png]"
          assert_select "p.img-caption", "jeremy in action"
        end
        assert_select "#contact-information" do
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
  
      it "should see less of dataless user" do
        get :view, { :id => 'joel' }
    
        assert_response :success
        assigns[:title].should == "Joel C. Adams"
        assigns[:last_updated].should == users(:joel).last_updated_dates.max
    
        assert_select "h1", "Joel C. Adams"
        assert_select "#contact-information" do
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
    end
    
    context "when logged in" do
      it "should edit a dataful user" do
        get :view, { :id => 'jeremy' }, user_session(:edit)
    
        assert_response :success
        assigns[:title].should == "Jeremy D. Frens"
        assigns[:last_updated].should == users(:jeremy).last_updated_dates.max
    
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
        assert_select "#contact-information" do
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
  
      it "should edit a dataless user" do
        get :view, { :id => 'joel' }, user_session(:edit)
    
        assert_response :success
        assigns[:title].should == "Joel C. Adams"
        assigns[:last_updated].should == users(:joel).last_updated_dates.max
    
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
        assert_select "#contact-information" do
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
      
      it "should have fewer editing fields for staff" do
        get :view, { :id => 'sharon' }, user_session(:edit)
    
        assert_response :success
        assigns[:title].should == "Sharon Gould"
        assigns[:last_updated].should == users(:sharon).last_updated_dates.max
        assert_select "#education", false, "should not have any option for education"
        assert_select "#interests", false, "should not have any interests"
      end
    end
  
    it "should redirect with an invalid id" do
      get :view, { :id => 'does not exist' }
      assert_redirected_to :action => 'list'
    end
  end
  
  context "update name action" do
    context "when logged in" do
      it "should update name" do
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
    end

    it "should redirect to login when NOT logged in" do
      xhr :post, :updated_name
      response.should redirect_to("/users/login")
    end
#    TODO: should_redirect_to_login_when_NOT_logged_in :update_name
  end
  
  context "update degree action" do
    it "should update when logged in" do
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
  
    it "should redirect to login when NOT logged in" do
      xhr :post, :updated_degree
      response.should redirect_to("/users/login")
    end
  end

  context "add degree action" do
    it "should add degree when logged in" do
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
  
    it "should redirect to login when NOT logged in" do
      xhr :post, :add_degree
      response.should redirect_to("/users/login")
    end
  end
  
  context "set office-phone action" do
    it "should be set when logged in" do
      keith = users(:keith)
      assert_nil keith.office_phone
    
      xhr :post, :set_user_office_phone,
        { :id => keith.id, :value => '616-111-9999' },
        user_session(:edit)
    
      assert_response :success
      keith.reload
      assert_equal '616-111-9999', keith.office_phone
    end
  
    it "should redirect to login when NOT logged in" do
      xhr :post, :set_user_office_phone
      response.should redirect_to("/users/login")
    end
  end
  
  context "set office-location action" do
    it "should be set when logged in" do
      keith = users(:keith)
      assert_nil keith.office_location
    
      xhr :post, :set_user_office_location,
        { :id => keith.id, :value => 'Funkytown' },
        user_session(:edit)
    
      assert_response :success
      keith.reload
      assert_equal 'Funkytown', keith.office_location
    end
  
    it "should redirect to login when NOT logged in" do
      xhr :post, :set_user_office_location
      response.should redirect_to("/users/login")
    end
  end
  
  context "updating job title" do
    it "should work when logged in" do
      keith = users(:keith)
      assert_nil keith.job_title
    
      xhr :post, :update_job_title,
        { :id => keith.id, :user => { :job_title => 'Professional Sidekick' } },
        user_session(:edit)
    
      assert_response :success
      assert_select_rjs :replace_html, "job_title" do
        response.body.should match(/Professional Sidekick/)
      end
      keith.reload
      assert_equal "Professional Sidekick", keith.job_title
    end
  
    it "should redirect to login when NOT logged in" do
      post :updated_job_title

      response.should redirect_to("/users/login")
    end
  end
  
  #
  # Helpers
  #
  private
  
  def assert_personnel_briefly(type, id, name)
    assert_response :success
    assert_select "table##{type}_listing.listing" do
      assert_select "tr:nth-child(1)" do
        assert_select "td:nth-child(2)" do
          assert_select "h2 a[href=/personnel/view/#{id}]", name
        end
      end
    end
  end
    
end
