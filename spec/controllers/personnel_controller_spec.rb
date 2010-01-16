require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonnelController do
  integrate_views
  
  fixtures :images, :image_tags, :degrees, :pages
  user_fixtures

  context "index action" do
    it "should redirect to viewing all" do
      get :index

      response.should render_template("personnel/index")
    end
  end

  context "list action" do
    context "done normally" do
      it "should set the proper data" do
        get :index
      
        assert_response :success
        assert_equal users(:sharon).updated_at, assigns(:last_updated)
        assert_equal [users(:joel), users(:jeremy), users(:keith)], assigns(:faculty)
        assert_equal [users(:fred)], assigns(:adjuncts)
        assert_equal [users(:randy)], assigns(:contributors)
        assert_equal [users(:larry)], assigns(:emeriti)
        assert_equal [users(:sharon)], assigns(:staff)
      end
    
      it "should set values for standard layout" do
        get :index
      
        assert_response :success
        assigns[:title].should == "Faculty & Staff"
        assigns[:last_updated].should == users(:sharon).updated_at
      end
    
      it "should see personel in a particular order" do
        get :index
    
        assert_response :success
        assert_select "#faculty ~ #adjuncts", true
        assert_select "#adjuncts ~ #emeriti", true
        assert_select "#emeriti ~ #contributors", true
        assert_select "#contributors ~ #staff", true
      end

      it "should have proper headers" do
        get :index
    
        assert_response :success
        assert_select "h1#faculty", "Faculty"
        assert_select "h1#adjuncts", "Adjunct Faculty"
        assert_select "h1#emeriti", "Emeriti"
        assert_select "h1#contributors", "Contributing Faculty"
        assert_select "h1#staff", "Staff"
      end
    
      it "should see dataless faculty" do
        get :index
    
        assert_response :success
        assert_select "table#faculty_listing.listing" do
          assert_select "tr:nth-child(1)" do
            assert_select "td a[href=/personnel/view/joel] img[src=#{images(:joel_headshot).url}]"
            assert_select "td:nth-child(2)" do
              assert_select "div.name" do
                assert_select "h2 a[href=/personnel/view/joel]", "Joel C. Adams"
                assert_select "p#joel_job_title", false, "should have no job title"
              end
              assert_select "p#joel_interests", false, "should have no interests paragraph"
              assert_select "p#joel_status", false, "should have no status paragraph"
            end
          end
        end
      end
  
      it "should see dataful faculty" do
        get :index
    
        assert_response :success
        assert_select "tr:nth-child(2)" do
          assert_select "td a[href=/personnel/view/jeremy] img[src=#{images(:jeremy_headshot).url}]"
          assert_select "td:nth-child(2)" do
            assert_select "div.name" do
              assert_select "h2 a[href=/personnel/view/jeremy]", "Jeremy D. Frens"
              assert_select "p#jeremy_job_title", "Assistant Professor"
            end
            assert_select "p#jeremy_interests", /Interests:\s+interest 1, interest 2/
            assert_select "p", "status of jeremy"
          end
        end
      end   
  
      it "should see adjuncts" do
        get :index
        assert_personnel_briefly "adjuncts", "fred", "Fred Ferwerda"
      end   
  
      it "should see emeriti" do
        get :index
        assert_personnel_briefly "emeriti", "larry", "Larry Nyhoff"
      end   
  
      it "should see contributing faculty" do
        get :index
        assert_personnel_briefly "contributors", "randy", "Randy Pruim"
      end   
  
      it "should see staff" do
        get :index
        assert_personnel_briefly "staff", "sharon", "Sharon Gould"
      end
    end
  
    it "should use date of last updated" do
      user = users(:jeremy)
      user.first_name = "bob"
      user.save!
    
      get :index
    
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
        should_have_remote_form_for_and_spinner("full_name_edit", "/personnel/update_name/3")
        assert_select "form" do
          assert_select "input[value=Jeremy D.]"
          assert_select "input[value=Frens]"
          assert_select "input[type=submit]"
          should_have_spinner :suffix => "name"
        end
        assert_select "p#job_title", "Assistant Professor"
        assert_select "p#job_title_edit form[onsubmit*=new Ajax.Request]" do
          assert_select "input[type=text][value=Assistant Professor]", true
          assert_select "input[type=submit]", true
          should_have_spinner :suffix => "job_title"
        end
        assert_select "#education" do
          assert_select "ul" do
            assert_select "li", 2, "should have two degrees"
            assert_select "div#degree_1 li", "B.A. in CS and MATH, Calvin College, 1992"
            assert_select "div#degree_3 li", "Ph.D. in CS, Indiana University, 2002"
          end
          assert_select "div#education_edits" do
            should_have_remote_form_for_and_spinner("degree_edit_1", "/personnel/update_degree/1")
            assert_select "form#degree_edit_1" do
              assert_select "input[type=text][value=B.A. in CS and MATH]"
              assert_select "input[type=text][value=Calvin College]"
              assert_select "input[type=text][value=http://cs.calvin.edu/]"
              assert_select "input[type=text][value=1992]"
              assert_select "input[type=submit]"
              should_have_spinner :number => 1
            end
            should_have_remote_form_for_and_spinner("degree_edit_3", "/personnel/update_degree/3")
            assert_select "form#degree_edit_3" do
              assert_select "input[type=text][value=Ph.D. in CS]"
              assert_select "input[type=text][value=Indiana University]"
              assert_select "input[type=text][value=http://cs.indiana.edu/]"
              assert_select "input[type=text][value=2002]"
              assert_select "input[type=submit]"
              should_have_spinner :number => 3
            end
          end
          assert_select "a[onclick*=/personnel/add_degree/3]", "Add degree"
        end
        assert_select "#interests" do
          assert_select "h2", "Interests"
          assert_select "p", "interest 1, interest 2"
          assert_select "a[href=/pages/_jeremy_interests/edit]", "edit interests"
        end
        assert_select "#status" do
          assert_select "h2", "Status"
          assert_select "p", "status of jeremy"
          assert_select "a[href=/pages/_jeremy_status/edit]", "edit status"
        end
        assert_select "#profile" do
          assert_select "h2", "Profile"
          assert_select "p", "profile of jeremy"
          assert_select "a[href=/pages/_jeremy_profile/edit]", "edit profile"
        end
      end

      it "should edit a dataless user" do
        get :view, { :id => 'joel' }, user_session(:edit)
    
        assert_response :success
        assigns[:title].should == "Joel C. Adams"
        assigns[:last_updated].should == users(:joel).last_updated_dates.max

        should_have_spinner(:suffix => "name")
        assert_select "div#full_name_header h1", "Joel C. Adams"
        should_have_remote_form_for_and_spinner("full_name_edit", "/personnel/update_name/5")
        assert_select "form" do
          assert_select "input[value=Joel C.]"
          assert_select "input[value=Adams]"
          assert_select "input[type=submit]"
          should_have_spinner :suffix => "name"
        end 
        assert_select "p#job_title", true
        assert_select "p#job_title_edit form[onsubmit*=new Ajax.Request]" do
          assert_select "input[type=text]", true
          assert_select "input[type=submit]", true
          should_have_spinner :suffix => "job_title"
        end
        assert_select "#education" do
          assert_select "ul", true
          assert_select "div#education_edits", true
          assert_select "a[onclick*=/personnel/add_degree/5]", "Add degree"
        end
        assert_select "#interests" do
          assert_select "h2", "Interests"
          assert_select "a[href=/pages/_joel_interests/edit]", "edit interests"
        end
        assert_select "#status" do
          assert_select "h2", "Status"
          assert_select "a[href=/pages/_joel_status/edit]", "edit status"
        end
        assert_select "#profile" do
          assert_select "h2", "Profile"
          assert_select "a[href=/pages/_joel_profile/edit]", "edit profile"
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

      response.should redirect_to(cogs_path)
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
