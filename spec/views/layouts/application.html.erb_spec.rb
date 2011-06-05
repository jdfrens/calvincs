require 'spec_helper'

describe "layouts/application.html.erb" do

  it "should render the application layout with a title" do
    view.should_receive(:title).and_return("<title>the title</title>")

    render

    rendered.should have_selector("head") do |head|
      head.should have_selector("title", :content => "the title")
    end
  end

  context "recursive rendering" do
    before(:each) do
      stub_template "layouts/_calvinjavascript.html.erb" => "the Calvin JavaScript"
      stub_template "layouts/_header.html.erb" => "header content"
      stub_template "layouts/_mainmenu.html.erb" => "the main menu"
      stub_template "layouts/_footer.html.erb" => "footer content"
    end

    it "should render the application layout with partials" do
      view.should_receive(:current_user).and_return(false)
      view.should_not_receive(:render2).with(:partial => 'layouts/adminmenu')

      render

      rendered.should contain("the Calvin JavaScript")
      rendered.should contain("header content")
      rendered.should have_selector("#navbar") do |navbar|
        navbar.should contain("the main menu")
      end
      rendered.should contain("footer content")
    end

    it "should render the application layout with administrative links" do
      view.should_receive(:current_user).and_return(true)
      stub_template "layouts/_adminmenu.html.erb" => "whatever"

      render

      rendered.should have_selector(".logout")
    end
  end

  describe "the title" do
    it "should have a default" do
      assign(:title, nil)

      render

      rendered.should have_selector("head title", :content => "Calvin College - Computer Science")
    end

    it "should use @title when set" do
      assign(:title, "Fancy Title for This Page")

      render

      rendered.should have_selector("head title", :content =>
                               "Calvin College - Computer Science - Fancy Title for This Page")
    end
  end

  it "should have accessibility links" do
    render

    rendered.should have_selector("div#accessibility") do |div|
      div.should have_selector("a", :href => "#navbar")
      div.should have_selector("a", :href => "#content")
    end
  end

  describe "footer" do
    it "should have a footer" do
      render

      rendered.should have_selector("div#footer")
    end
  end

  describe "the flash" do
    it "should not have a flash notice if not set" do
      render

      rendered.should_not have_selector(".notice")
    end

    it "should have a flash error" do
      flash[:notice] = ["notice me!"]

      render

      rendered.should have_selector(".notice", :content => "notice me!")
    end

    it "should not have a flash error if not set" do
      render

      rendered.should_not have_selector(".error")
    end

    it "should have a flash error" do
      flash[:error] = ["the error message."]

      render

      rendered.should have_selector(".error", :content => "the error message.")
    end
  end
end
