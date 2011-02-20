require 'spec_helper'

describe "personnel/index.html.erb" do
  before(:each) do
    @faculty = mock("faculty")
    @adjuncts = mock("adjuncts")
    @emeriti = mock("emeriti")
    @contributors = mock("contributors")
    @staff = mock("staff")
    @admin = mock("admin")
    assign(:faculty, @faculty)
    assign(:adjuncts, @adjuncts)
    assign(:emeriti, @emeriti)
    assign(:contributors, @contributors)
    assign(:staff, @staff)
    assign(:admin, @admin)
  end

  context "when logged in" do
    before(:each) do
      view.should_receive(:current_user).and_return(mock_model(User))
      view.should_receive(:render_personnel).with(@faculty).and_return("faculty listing")
      view.should_receive(:render_personnel).with(@adjuncts).and_return("adjuncts listing")
      view.should_receive(:render_personnel).with(@emeriti).and_return("emeriti listing")
      view.should_receive(:render_personnel).with(@contributors).and_return("contributors listing")
      view.should_receive(:render_personnel).with(@staff).and_return("staff listing")
      view.should_receive(:render_personnel).with(@admin).and_return("admin listing")

      render
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
      rendered.should have_selector("table", :content => "faculty listing")
      rendered.should have_selector("table", :content => "adjuncts listing")
      rendered.should have_selector("table", :content => "emeriti listing")
      rendered.should have_selector("table", :content => "contributors listing")
      rendered.should have_selector("table", :content => "staff listing")
      rendered.should have_selector("table", :content => "admin listing")
    end
  end

  context "when not logged in" do
    before(:each) do
      view.should_receive(:current_user).and_return(nil)
      view.stub(:render_personnel).and_return("rendered personnel")

      render
    end


    it "should not show admins" do
      rendered.should_not have_selector("h1#admin")
    end

    it "should not have admins listing" do
      rendered.should_not have_selector("#admin_listing")
    end
  end
end
