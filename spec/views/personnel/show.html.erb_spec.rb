require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/show.html.erb" do
  user_fixtures

  it "should render a bunch of partials" do
    assigns[:user] = user = mock_model(User, :full_name => "Full J. Name")

    template.should_receive(:render).with(:partial => 'job_title').and_return("")
    template.should_receive(:render).with(:partial => 'pages/image').and_return("")
    template.should_receive(:render).with(:partial => 'contact_information').and_return("")
    template.should_receive(:render).with(:partial => 'education').and_return("")
    template.should_receive(:render).with(:partial => 'interests').and_return("")
    template.should_receive(:render).with(:partial => 'status').and_return("")
    template.should_receive(:render).with(:partial => 'profile').and_return("")

    render "personnel/show"

    response.should have_selector("h1", :content => "Full J. Name")
  end

  it "should see dataful user" do
    assigns[:user] = users(:jeremy)
    
    render "personnel/show"

    assert_select "h1", "Jeremy D. Frens"
    assert_select "p#job_title", "Assistant Professor"
    # TODO: why is this missing?
#    assert_select "div.img-right-unusable" do
#      assert_select "img#cool-pic[src=/jeremyaction.png]"
#      assert_select "p.img-caption", "jeremy in action"
#    end
    assert_select "#education" do
      assert_select "h2", "Education"
      assert_select "ul" do
        assert_select "li", 2, "should have two degrees"
        assert_select "div#degree_1 li", "B.A. in CS and MATH, Calvin College, 1992"
        assert_select "div#degree_3 li", "Ph.D. in CS, Indiana University, 2002"
      end
    end
    assert_select "#interests" do
      assert_select "h2", "Interests"
      assert_select "p", "interest 1, interest 2"
      assert_select "a[href=/p/jeremy_interests]", false
    end
    assert_select "#status", false, "should NOT see status when NOT logged in"
    assert_select "#profile" do
      assert_select "h2", "Profile"
      assert_select "p", "profile of jeremy"
      assert_select "a[href=/p/jeremy_profile]", false
    end
  end

  it "should see less of dataless user" do
    assigns[:user] = users(:joel)

    render "personnel/show"

    assert_select "h1", "Joel C. Adams"
    assert_select "#education", false
    assert_select "#interests", false
    assert_select "#status", false
    assert_select "#profile", false
  end
end
