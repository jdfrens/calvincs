require 'spec_helper'

describe PersonnelController do

  user_fixtures

  context 'index action' do
    it "should set the proper data" do
      faculty = [mock_model(User)]
      adjuncts = [mock_model(User)]
      emeriti = [mock_model(User)]
      contributors = [mock_model(User)]
      admin = [mock_model(User)]
      staff = [mock_model(User)]
      last_updated = mock("last updated")

      Role.should_receive(:users_ordered_by_name).with("faculty").and_return(faculty)
      Role.should_receive(:users_ordered_by_name).with("adjuncts").and_return(adjuncts)
      Role.should_receive(:users_ordered_by_name).with("emeriti").and_return(emeriti)
      Role.should_receive(:users_ordered_by_name).with("contributors").and_return(contributors)
      Role.should_receive(:users_ordered_by_name).with("staff").and_return(staff)
      Role.should_receive(:users_ordered_by_name).with("admin").and_return(admin)
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
      assigns[:admin].should == admin
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

  context "form for a new person" do
    it "should redirect if not logged in" do
      get :new

      response.should redirect_to(login_path)
    end

    it "should show the new-user form when logged in" do
      get :new, {}, user_session(:edit)

      response.should render_template("personnel/new")
      assigns[:user].should be_new_record
      assigns[:user].should be_instance_of(User)
    end
  end

  context "creating a new person" do
    it "should redirect if not logged in" do
      get :create, { :user => "params" }

      response.should redirect_to(login_path)
    end

    it "should create a new person" do
      user = mock_model(User, :username => "the username")

      User.should_receive(:new).with("params").and_return(user)
      user.should_receive(:active=).with(true)
      user.should_receive(:email_address=).with("the username@calvin.edu")
      user.should_receive(:save).and_return(true)
      
      get :create, { :user => "params" }, user_session(:edit)

      response.should redirect_to(people_path)
    end

    it "should fail to create a new person" do
      user = mock_model(User, :username => "the username")

      User.should_receive(:new).with("params").and_return(user)
      user.should_receive(:active=).with(true)
      user.should_receive(:email_address=).with("the username@calvin.edu")
      user.should_receive(:save).and_return(false)

      get :create, { :user => "params" }, user_session(:edit)

      response.should render_template("personnel/new")
    end
  end
  
  context "editing a person" do
    it "should redirect if not logged in" do
      get :edit, { :id => "bob" }

      response.should redirect_to(login_path)
    end

    it "should show editing form" do
      get :edit, { :id => users(:joel).username }, user_session(:edit)

      response.should render_template("personnel/edit")
      assigns[:user].should == users(:joel)
    end
  end

  context "editing the password of a person" do
    it "should redirect if not logged in" do
      get :editpassword, { :id => "bob" }

      response.should redirect_to(login_path)
    end

    it "should find user and render form" do
      get :editpassword, { :id => users(:joel).username }, user_session(:edit)

      response.should render_template("personnel/editpassword")
      assigns[:user].should == users(:joel)
    end
  end

  context "updating a person" do
    it "should redirect if not logged in" do
      put :update, { :id => "joel" }

      response.should redirect_to(login_path)
    end

    it "should update and redirect" do
      user = users(:joel)

      put :update, { :id => user.username, :user => { :first_name => "Billy" } }, user_session(:edit)

      response.should redirect_to(person_path(user))
      flash[:notice].should == "Person updated."
      user.reload
      user.full_name.should == "Billy Adams"
    end

    it "should fail to update and re-edit" do
      user = users(:joel)

      put :update, { :id => user.username, :user => { :office_phone => "not valid" }}, user_session(:edit)

      response.should render_template("personnel/edit")
      flash[:error].should == "Problem updating person."
    end
  end
end
