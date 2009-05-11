require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.erb" do

  it "should render the application layout with a title" do
    template.should_receive(:title).and_return("<title>the title</title>")
    render "layouts/application"
    response.should have_tag("head") do
      with_tag("title", "the title")
    end
  end

  it "should render the application layout with partials" do
    template.should_receive(:current_user).and_return(false)
    template.should_receive(:render).with(:partial => 'layouts/mainmenu').
      and_return("<div id='menu'></div>")
    template.should_receive(:render).with(:partial => 'layouts/googlesearch').
      and_return("<div id='googlesearch'></div>")
    template.should_receive(:render).with(:partial => 'layouts/footer').
      and_return("<div id='footer'></div>")
    template.should_not_receive(:render).with(:partial => 'layouts/adminmenu')

    render "layouts/application"

    response.should have_tag("#navbar") do
      with_tag("#menu")
      with_tag("#googlesearch")
    end
    response.should have_tag("#footer")
  end

  it "should render the application layout with administrative links" do
    template.should_receive(:current_user).and_return(true)
    template.should_receive(:render).with(:partial => 'layouts/adminmenu')

    render "layouts/application"

    response.should have_tag(".logout")
  end

  describe "the title" do
    it "should have a default" do
      assigns[:title] = nil
      
      render "layouts/application"

      response.should have_tag("head title", "Calvin College Computer Science")
    end

    it "should use @title when set" do
      assigns[:title] = "Fancy Title for This Page"

      render "layouts/application"

      response.should have_tag("head title",
        "Calvin College Computer Science - Fancy Title for This Page")
    end
  end

  it "should have accessibility links" do
    render "layouts/application"

    response.should have_tag("div#accessibility") do
      with_tag "a[href=#navbar]"
      with_tag "a[href=#content]"
    end
  end

  describe "footer" do
    it "should have a footer" do
      render "layouts/application"

      response.should have_tag("div#footer-css") do
        with_tag "a[href=mailto:computing@calvin.edu]", "Computer Science Department"
      end
    end

    it "should not have an updated time if @last_updated unset" do
      render "layouts/application"

      response.should_not have_tag("#last_updated")
    end

    it "should not have an updated time if @last_updated unset" do
      last_updated = mock("last updated")
      assigns[:last_updated] = last_updated
      last_updated.should_receive(:to_s).with(:last_updated).and_return("March 7, 1970")

      render "layouts/application"

      response.should have_tag("#last_updated", "Last updated March 7, 1970.")
    end
  end
end

