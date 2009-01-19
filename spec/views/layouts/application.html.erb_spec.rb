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
    template.should_receive(:render).with(:partial => 'layouts/mainmenu').and_return("<div id='menu'></div>")
    template.should_receive(:render).with(:partial => 'layouts/googlesearch').and_return("<div id='googlesearch'></div>")
    template.should_receive(:render).with(:partial => 'layouts/tasks').and_return("<div id='tasks'></div>")
    template.should_receive(:render).with(:partial => 'layouts/footer').and_return("<div id='footer'></div>")
    template.should_not_receive(:render).with(:partial => 'layouts/adminmenu')

    render "layouts/application"

    response.should have_tag("#navbar") do
      with_tag("#menu")
      with_tag("#googlesearch")
      with_tag("#tasks")
    end
    response.should have_tag("#footer")
  end

  it "should render the application layout with administrative links" do
    template.should_receive(:current_user).and_return(true)
    template.should_receive(:render).with(:partial => 'layouts/adminmenu')

    render "layouts/application"
    response.should have_tag(".logout")
  end

end

