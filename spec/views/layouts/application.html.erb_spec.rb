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
    template.should_receive(:render).with(:partial => 'layouts/footer').
            and_return("<div id='footer'></div>")
    template.should_not_receive(:render).with(:partial => 'layouts/adminmenu')

    render "layouts/application"

    response.should have_tag("#navbar") do
      with_tag("#menu")
    end
    response.should have_tag("#GoogleSearch")
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

      response.should have_tag("div#footer")
    end
  end

  describe "the flash" do
    it "should not have a flash error if not set" do
      render "layouts/application"

      response.should_not have_selector("#error")
    end

    it "should have a flash error" do
      flash[:error] = "the error message."
      
      render "layouts/application"

      response.should have_selector("#error", :content => "the error message.")
    end
  end
end

