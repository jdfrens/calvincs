require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonnelController, "with views" do
  integrate_views

  fixtures :images, :image_tags, :degrees, :pages
  user_fixtures

  context "show action" do
    context "when logged in" do
      it "should edit a dataful user" do
        get :show, { :id => 'jeremy' }, user_session(:edit)

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
        get :show, { :id => 'joel' }, user_session(:edit)

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
        get :show, { :id => 'sharon' }, user_session(:edit)

        assert_response :success
        assigns[:title].should == "Sharon Gould"
        assigns[:last_updated].should == users(:sharon).last_updated_dates.max
        assert_select "#education", false, "should not have any option for education"
        assert_select "#interests", false, "should not have any interests"
      end
    end
  end
end

describe PersonnelController, "without views" do

  fixtures :images, :image_tags, :degrees, :pages
  user_fixtures

  context 'index action' do
    it "should set the proper data" do
      faculty = [mock_model(User)]
      adjuncts = [mock_model(User)]
      emeriti = [mock_model(User)]
      contributors = [mock_model(User)]
      staff = [mock_model(User)]
      last_updated = mock("last updated")

      Role.should_receive(:users_ordered_by_name).with("faculty").and_return(faculty)
      Role.should_receive(:users_ordered_by_name).with("adjuncts").and_return(adjuncts)
      Role.should_receive(:users_ordered_by_name).with("emeriti").and_return(emeriti)
      Role.should_receive(:users_ordered_by_name).with("contributors").and_return(contributors)
      Role.should_receive(:users_ordered_by_name).with("staff").and_return(staff)
      controller.should_receive(:last_updated).
              with(faculty + adjuncts + emeriti + contributors + staff).
              and_return(last_updated)

      get :index

      assert_response :success
      assigns[:title].should == "Faculty & Staff"
      assigns[:last_updated].should == last_updated
      assigns[:faculty].should == faculty
      assigns[:adjuncts].should == adjuncts
      assigns[:emeriti].should == emeriti
      assigns[:contributors].should == contributors
      assigns[:staff].should == staff
    end
  end
  
  context "show action" do
    it "should collect data and show" do
      image = mock_model(Image)

      Image.should_receive(:pick_random).with("jeremy").and_return(image)

      get :show, { :id => 'jeremy' }

      assigns[:image].should == image
      assigns[:title].should == "Jeremy D. Frens"
      assigns[:last_updated].should == users(:jeremy).last_updated_dates.max
    end

    it "should redirect with an invalid id" do
      get :show, { :id => 'does not exist' }

      response.should redirect_to(cogs_path)
    end
  end
end
