require 'spec_helper'

describe "home/sitemap.xml.builder" do

  before(:each) do
    assign(:pages, [])
    assign(:courses, [])
    assign(:people, [])
  end

  it "should uses an xmlns" do
    render

    rendered.should have_selector("urlset", :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9")
  end

  it "should have the root url with a high priority" do
    render

    rendered.should have_selector("urlset") do |urlset|
      urlset.should have_selector("url") do |url|
        url.should have_selector("loc", :content => "http://cs.calvin.edu/")
        url.should have_selector("priority", :content => "0.8")
      end
    end
  end

  ["courses", "events", "newsitems"].each do |component|
    it "should have a link for #{component}" do
      render

      rendered.should have_selector("loc", :content => "http://cs.calvin.edu/#{component}")
    end
  end

  it "should handle pages" do
    time = Chronic.parse("7 March 1970")
    assign(:pages, [mock_model(Page, :identifier => "matthew", :updated_at => time),
                    mock_model(Page, :identifier => "mark", :updated_at => time),
                    mock_model(Page, :identifier => "luke", :updated_at => time)])

    render

    rendered.should have_selector("url") do |url|
      url.should have_selector("loc", :content => "http://cs.calvin.edu/p/matthew")
      url.should have_selector("lastmod", :content => "1970-03-07")
    end
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/p/mark")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/p/luke")
  end

  it "should handle courses" do
    assign(:courses, [mock_model(Course, :url => "http://cs.calvin.edu/somewhere"),
                      mock_model(Course, :url => "http://cs.calvin.edu/foobar"),
                      mock_model(Course, :url => "http://cs.calvin.edu/elsewhere")])

    render

    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/somewhere")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/foobar")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/elsewhere")
  end

  it "should handle only courses on our server" do
    assign(:courses, [mock_model(Course, :url => "http://example.com/foobar")])

    render

    rendered.should_not have_selector("loc", :content => "http://example.com/foobar")
  end

  it "should link to people page" do
    render

    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/people")
  end

  it "should handle people" do
    time = Chronic.parse("5 May 1999")
    assign(:people, [mock_model(User, :username => "jcalvin", :last_updated_dates => [time]),
                     mock_model(User, :username => "mluther", :last_updated_dates => [time]),
                     mock_model(User, :username => "jknox", :last_updated_dates => [time])])

    render

    rendered.should have_selector("url") do |url|
      url.should have_selector("loc", :content => "http://cs.calvin.edu/people/jcalvin")
      url.should have_selector("lastmod", :content => "1999-05-05")
    end
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/people/mluther")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/people/jknox")
  end

  it "should have activities" do
    render

    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/activities/connect/")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/activities/blasted/")
  end

  it "should have books" do
    render

    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/books/c++/intro/3e/")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/books/c++/ds/2e/")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/books/fortran/")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/books/java/intro/1e/")
    rendered.should have_selector("loc", :content => "http://cs.calvin.edu/books/networking/labbook/")
  end
end
