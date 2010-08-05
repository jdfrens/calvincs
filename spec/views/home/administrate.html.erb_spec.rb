require 'spec_helper'

describe "home/administrate.html.erb" do

  it "should have header" do
    render

    rendered.should have_selector("h1", :content => "Master Administration")
  end

  it "should have a news menu" do
    render

    rendered.should have_selector('h2', :content => "News and Events")
    rendered.should have_selector("ul#news_administration") do |ul|
      ul.should have_selector("a", :href => "/newsitems/new", :content => "Create news item")
      ul.should have_selector("a", :href => "/events/new?kind=Colloquium", :content => "Create new colloquium")
      ul.should have_selector("a", :href => "/events/new?kind=Conference", :content => "Create new conference")
    end
  end

  it "should have a page menu" do
    render

    assert_select 'h2', "Webpages and Other Documents"
    assert_select "ul#content_administration" do
      assert_select "a[href=/p]", /list/i
      assert_select "a[href=/p/new]", /create/i
    end
  end

  it "should have a album menu" do
    render

    rendered.should have_selector("h2", :content => "Images")
    rendered.should have_selector("#picture_administration") do |ul|
      ul.should have_selector("a", :href => images_path, :content => "List images")
      ul.should have_selector("a", :href => new_image_path, :content => "Add image")
      ul.should have_selector("a", :href => refresh_images_path, :content => "Refresh dimensions")
    end
  end

  it "should have a courses menu" do
    render

    assert_select 'h2', "Courses"
    assert_select "ul#course_administration" do
      assert_select "a[href=/courses]", /list/i
      assert_select "a[href=/courses/new]", /create/i
    end
  end

end
