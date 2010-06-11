require 'spec_helper'

describe "/personnel/index.html.erb" do
  context "when logged in" do
    before(:each) do
      assigns[:faculty] = faculty = mock("faculty")
      assigns[:adjuncts] = adjuncts = mock("adjuncts")
      assigns[:emeriti] = emeriti = mock("emeriti")
      assigns[:contributors] = contributors = mock("contributors")
      assigns[:staff] = staff = mock("staff")
      assigns[:admin] = admin = mock("admin")

      template.should_receive(:current_user).and_return(mock_model(User))
      template.should_receive(:render).with(:partial => 'user', :collection => faculty).
              and_return("<div>faculty listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => adjuncts).
              and_return("<div>adjuncts listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => emeriti).
              and_return("<div>emeriti listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => contributors).
              and_return("<div>contributors listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => staff).
              and_return("<div>staff listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => admin).
              and_return("<div>admin listing</div>")

      render "personnel/index"
    end

    it "should show people in a particular order" do
      assert_select "#faculty ~ #adjuncts", true
      assert_select "#adjuncts ~ #emeriti", true
      assert_select "#emeriti ~ #contributors", true
      assert_select "#contributors ~ #staff", true
      assert_select "#staff ~ #admin", true
    end

    it "should have proper headers" do
      assert_select "h1#faculty", "Faculty"
      assert_select "h1#adjuncts", "Adjunct Faculty"
      assert_select "h1#emeriti", "Emeriti"
      assert_select "h1#contributors", "Contributing Faculty"
      assert_select "h1#staff", "Staff"
      assert_select "h1#admin", "Unseen System Administrators"
    end

    it "should have listings" do
      response.should have_selector("div", :content => "faculty listing")
      response.should have_selector("div", :content => "adjuncts listing")
      response.should have_selector("div", :content => "emeriti listing")
      response.should have_selector("div", :content => "contributors listing")
      response.should have_selector("div", :content => "staff listing")
      response.should have_selector("div", :content => "admin listing")
    end
  end

  context "when not logged in" do
    before(:each) do
      assigns[:faculty] = faculty = mock("faculty")
      assigns[:adjuncts] = adjuncts = mock("adjuncts")
      assigns[:emeriti] = emeriti = mock("emeriti")
      assigns[:contributors] = contributors = mock("contributors")
      assigns[:staff] = staff = mock("staff")

      template.should_receive(:current_user).and_return(nil)
      template.should_receive(:render).with(:partial => 'user', :collection => faculty).
              and_return("<div>faculty listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => adjuncts).
              and_return("<div>adjuncts listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => emeriti).
              and_return("<div>emeriti listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => contributors).
              and_return("<div>contributors listing</div>")
      template.should_receive(:render).with(:partial => 'user', :collection => staff).
              and_return("<div>staff listing</div>")

      render "personnel/index"
    end


    it "should not show admins" do
      response.should_not have_selector("h1#admin")
    end

    it "should not have admins listing" do
      response.should_not have_selector("#admin_listing")
    end
  end
end
