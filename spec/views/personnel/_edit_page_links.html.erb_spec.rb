require 'spec_helper'

describe "personnel/_edit_page_links.html.erb" do
  context "for a page that doesn't exist" do
    before do
      user = mock_model(User)
      assign(:user, user)

      view.should_receive(:page_type).at_least(:once).and_return("foobar")
      user.should_receive(:page_identifier).with("foobar").
              at_least(:once).and_return("foobar identifier")
      user.should_receive(:subpage).with("foobar").
              at_least(:once).and_return(nil)

      render
    end

    it "should have a create-page link" do
      rendered.should have_selector("a", :href => edit_page_path("foobar identifier"), :content => "create foobar")
    end

    it "should not have an edit-page link" do
      rendered.should_not contain("edit foobar")
    end

    it "should not have a delete-page button" do
      rendered.should_not have_selector("input", :type => "submit",  :value => "delete foobar")
    end
  end

  context "for an existing page" do
    before do
      user = mock_model(User)
      assign(:user, user)
      page = mock_model(Page)

      view.should_receive(:page_type).at_least(:once).and_return("foobar")
      user.should_receive(:page_identifier).with("foobar").
              at_least(:once).and_return("foobar identifier")
      user.should_receive(:subpage).with("foobar").
              at_least(:once).and_return(page)

      render
    end

    it "should have an edit-page link" do
      rendered.should have_selector("a", :href => edit_page_path("foobar identifier"),
                                         :content => "edit foobar")
    end

    it "should have a delete-page button" do
      rendered.should have_selector("input", :type => "submit",  :value => "delete foobar")
    end

    it "should not have a create-page link" do
      rendered.should_not contain("create foobar")
    end
  end
end
