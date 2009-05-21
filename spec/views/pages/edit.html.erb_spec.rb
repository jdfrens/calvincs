require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/edit.html.erb" do

  describe "render a normal page" do
    before(:each) do
      @page = mock_model(Page, :subpage? => false, :title => "Mission Statement",
              :content => "We state our mission.", :identifier => "mission")
      assigns[:page] = @page
      template.should_not_receive(:render).with(:partial => "image")
      expect_textilize("We state our mission.")
      template.should_receive(:in_place_editor_field).with(:page, "title").and_return("title's in-place editor")
      template.should_receive(:in_place_editor_field).with(:page, "identifier").and_return("identifier's in-place editor")

      render "/pages/edit"
    end

    it "should have an editor for the title" do
      response.should have_selector("h1") do |h1|
        h1.should contain("title's in-place editor")
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
      response.should have_selector("form", :action => "/pages/update_page_content/#{@page.id}") do |element|
        element.should contain("We state our mission.")
      end
    end

    it "should have an editor for the identifier" do
      response.should have_selector("p.identifier") do |p|
        p.should contain("identifier's in-place editor")
      end
    end

    it "should link back to show the page" do
      pending()
      response.should have_selector("a", :href => "/p/mission", :content => 'show page')
    end
  end

  describe "render a subpage" do
    before(:each) do
      @page = mock_model(Page, :subpage? => true, :title => "Whatever", :content => "No, really, whatever!")
      assigns[:page] = @page
      template.should_not_receive(:render).with(:partial => "image")
      template.should_receive(:in_place_editor_field).with(:page, "title").and_return("title's in-place editor")
      template.should_receive(:in_place_editor_field).with(:page, "identifier").and_return("identifier's in-place editor")

      render "/pages/edit"
    end

    it "should annotate the title" do
      response.should have_selector("h1") do |h1|
        h1.should have_selector("em", :content => "rarely seen")
      end
    end
  end
end
