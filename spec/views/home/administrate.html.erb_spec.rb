require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/home/administrate.html.erb" do

  it "should have header" do
    render "home/administrate"

    response.should have_tag("h1", "Master Administration")
  end

  it "should have a news menu" do
    render "home/administrate"

    response.should have_tag('h2', "News and Events")
    response.should have_tag("ul#news_administration") do
      with_tag("a[href=/newsitems/new]", /create news item/i)
      with_tag("a[href=/events/new?kind=Colloquium]", /create new colloquium/i)
      with_tag("a[href=/events/new?kind=Conference]", /create new conference/i)
    end
  end

  it "should have a page menu" do
    render "home/administrate"

    assert_select 'h2', "Webpages and Other Documents"
    assert_select "ul#content_administration" do
      assert_select "a[href=/p]", /list/i
      assert_select "a[href=/p/new]", /create/i
    end
  end

  it "should have a album menu" do
    render "home/administrate"

    assert_select "h2", "Image Album"
    assert_select "ul#album_administration" do
      assert_select "a[href=/images]", /list images/i
      assert_select "a[href=/images/new]", /add image/i
    end
  end

  it "should have a courses menu" do
    render "home/administrate"

    assert_select 'h2', "Courses"
    assert_select "ul#course_administration" do
      assert_select "a[href=/courses]", /list/i
      assert_select "a[href=/courses/new]", /create/i
    end
  end

end
