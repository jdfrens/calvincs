require 'spec_helper'

describe PagesHelper do

  describe "displaying the title of a page" do
    it "should use the actual title of a normal page" do
      page = mock_model(Page, :subpage? => false, :title => "the lovely title")

      helper.page_title(page).should == "the lovely title"
    end

    it "should have a special title for a subpage" do
      page = mock_model(Page, :subpage? => true, :title => "you can't see me!!!", :identifier => "_the_subpage")

      helper.page_title(page).should == "SUBPAGE identified as _the_subpage"
    end
  end

  describe "#show_page_link" do
    it "should use 'show this page' for normal pages" do
      page = Page.new(:identifier => "foobar")
      helper.show_page_link(page).
        should have_selector("a", :href => "/p/foobar", :content => "show this page")
    end

    it "should use 'show home page' for home-page content" do
      page = Page.new(:identifier => "_home_splash")
      helper.show_page_link(page).
        should have_selector("a", :href => "/", :content => "show home page")
    end

    context "faculty context" do
      before(:each) do
        @person = User.new(:username => "kvlinden")
        @page = Page.new(:identifier => "_kvlinden_interests")
        User.stub(:find_by_username).with("kvlinden").and_return(@person)
      end

      it "should use 'show faculty page' for faculty content" do
        helper.show_page_link(@page).
          should have_selector("a", :href => people_path, :content => "show faculty page")
      end

      it "should use 'show username page' for faculty content" do
        helper.show_page_link(@page).
          should have_selector("a", :href => person_path(@person), :content => "show kvlinden page")
      end

      it "should have both links" do
        helper.show_page_link(@page).should contain("show faculty page, show kvlinden page")
      end
    end
  end
end
