require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/edit.html.erb" do

  describe "render a normal page" do
    before(:each) do
      @page = mock_model(Page, :subpage? => false, :title => "Mission Statement",
              :content => "We state our mission.", :identifier => "mission")
      assigns[:page] = @page
      template.should_not_receive(:render).with(:partial => "image")
      expect_textilize("We state our mission.")

      render "/pages/edit"
    end

    it "should have an editor for the title" do
      response.should have_selector("h1") do |h1|
        h1.should contain("editable")
      end
    end

    it "should not annotate the title" do
      response.should_not have_selector("em", :content => "rarely seen")
    end

    it "should display the textilized page content" do
      response.should have_selector("#page_content") do |element|
        element.should contain("We state our mission.")
      end
    end

    it "should have an editor for the page content" do
      response.should have_selector("form", :class => "edit_page") do |element|
        element.should have_selector("textarea", :content => "We state our mission.")
      end
    end

    it "should have an editor for the identifier" do
      response.should have_selector("p.identifier") do |p|
        p.should contain("editable")
      end
    end

    it "should link back to show the page" do
      response.should have_selector("a", :href => page_path(@page), :content => 'show page')
    end
  end

  describe "render a subpage" do
    before(:each) do
      @page = mock_model(Page, :subpage? => true, :title => "Whatever",
              :content => "No, really, whatever!", :identifier => "whatever")
      assigns[:page] = @page
      template.should_not_receive(:render).with(:partial => "image")
      template.should_not_receive(:in_place_editor_field).with(:page, "title")

      render "/pages/edit"
    end

    it "should have a note instead of a title" do
      response.should have_selector("p", :content => "This is a subpage, and subpages do not have titles.")
    end
  end
end
