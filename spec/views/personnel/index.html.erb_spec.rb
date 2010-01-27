require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/index.html.erb" do
  before(:each) do
    assigns[:faculty] = faculty = mock("faculty")
    assigns[:adjuncts] = adjuncts = mock("adjuncts")
    assigns[:emeriti] = emeriti = mock("emeriti")
    assigns[:contributors] = contributors = mock("contributors")
    assigns[:staff] = staff = mock("staff")

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

  it "should show people in a particular order" do
    assert_select "#faculty ~ #adjuncts", true
    assert_select "#adjuncts ~ #emeriti", true
    assert_select "#emeriti ~ #contributors", true
    assert_select "#contributors ~ #staff", true
  end

  it "should have proper headers" do
    assert_select "h1#faculty", "Faculty"
    assert_select "h1#adjuncts", "Adjunct Faculty"
    assert_select "h1#emeriti", "Emeriti"
    assert_select "h1#contributors", "Contributing Faculty"
    assert_select "h1#staff", "Staff"
  end

  it "should have listings" do
    response.should have_selector("div", :content => "faculty listing")
    response.should have_selector("div", :content => "adjuncts listing")
    response.should have_selector("div", :content => "emeriti listing")
    response.should have_selector("div", :content => "contributors listing")
    response.should have_selector("div", :content => "staff listing")
  end
end
