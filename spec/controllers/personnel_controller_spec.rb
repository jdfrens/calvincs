require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonnelController do

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

      response.should render_template("personnel/index")
      assigns[:title].should == "Faculty & Staff"
      assigns[:last_updated].should == last_updated
      assigns[:faculty].should == faculty
      assigns[:adjuncts].should == adjuncts
      assigns[:emeriti].should == emeriti
      assigns[:contributors].should == contributors
      assigns[:staff].should == staff
    end
  end

  context "showing a person" do
    it "should show a person" do
      updated = Time.now
      user = mock_model(User, :full_name => "Full J. Name", "username" => "fjname", :last_updated_dates => updated)
      image = mock_model(Image)

      User.should_receive(:find_by_username).with("fjname").and_return(user)

      get :show, { :id => "fjname" }

      response.should render_template("personnel/show")
      assigns[:user].should == user
      assigns[:title].should == "Full J. Name"
      assigns[:last_updated].should == updated
    end

    it "should redirect to index if username not found" do
      User.should_receive(:find_by_username).with("not2Bfound").and_return(nil)

      get :show, { :id => "not2Bfound" }

      response.should redirect_to(people_path)
    end
  end

  context "editing a person" do
    it "should redirect if not logged in" do
      get :edit, { :id => "1243" }

      response.should redirect_to(login_path)
    end

    it "should show editing form" do
      get :edit, { :id => users(:joel).id }, user_session(:edit)

      response.should render_template("personnel/edit")
      assigns[:user].should == users(:joel)
    end
  end

  context "updating a person" do
    it "should update and redirect" do
      user = users(:joel)

      put :update, { :id => user.id, :user => { :first_name => "Billy" } }, user_session(:edit)

      response.should redirect_to(people_path)
      user.reload
      user.full_name.should == "Billy Adams"
    end
  end
end
