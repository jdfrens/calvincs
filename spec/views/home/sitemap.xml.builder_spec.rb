require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/home/sitemap.xml.builder" do

  before(:each) do
    assigns[:pages] = []
    assigns[:courses] = []
    assigns[:people] = []
  end

  it "should uses an xmlns" do
    render "/home/sitemap.xml"

    response.should have_selector("urlset", :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9")
  end

  it "should have the root url with a high priority" do
    render "/home/sitemap.xml"

    response.should have_selector("urlset") do |urlset|
      urlset.should have_selector("url") do |url|
        url.should have_selector("loc", :content => "http://cs.calvin.edu/")
        url.should have_selector("priority", :content => "0.8")
      end
    end
  end

  ["courses", "events", "newsitems"].each do |component|
    it "should have a link for #{component}" do
      render "/home/sitemap.xml"

      response.should have_selector("loc", :content => "http://cs.calvin.edu/#{component}")
    end
  end

  it "should handle pages" do
    assigns[:pages] = [mock_model(Page, :identifier => "matthew"),
                       mock_model(Page, :identifier => "mark"),
                       mock_model(Page, :identifier => "luke")]

    render "/home/sitemap.xml"

    response.should have_selector("loc", :content => "http://cs.calvin.edu/p/matthew")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/p/mark")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/p/luke")
  end

  it "should handle courses" do
    assigns[:courses] = [mock_model(Course, :url => "http://cs.calvin.edu/somewhere"),
                         mock_model(Course, :url => "http://cs.calvin.edu/foobar"),
                         mock_model(Course, :url => "http://cs.calvin.edu/elsewhere")]

    render "/home/sitemap.xml"

    response.should have_selector("loc", :content => "http://cs.calvin.edu/somewhere")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/foobar")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/elsewhere")
  end

  it "should handle only courses on our server" do
    assigns[:courses] = [mock_model(Course, :url => "http://example.com/foobar")]

    render "/home/sitemap.xml"

    response.should_not have_selector("loc", :content => "http://example.com/foobar")
  end

  it "should link to people page" do
    render "/home/sitemap.xml"

    response.should have_selector("loc", :content => "http://cs.calvin.edu/people")    
  end

  it "should handle people" do
    assigns[:people] = [mock_model(User, :username => "jcalvin"),
                        mock_model(User, :username => "mluther"),
                        mock_model(User, :username => "jknox")]

    render "/home/sitemap.xml"

    response.should have_selector("loc", :content => "http://cs.calvin.edu/people/jcalvin")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/people/mluther")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/people/jknox")
  end

  it "should have activities" do
    render "/home/sitemap.xml"

    response.should have_selector("loc", :content => "http://cs.calvin.edu/activities/connect/")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/activities/blasted/")
  end

  it "should have books" do
    render "/home/sitemap.xml"

    response.should have_selector("loc", :content => "http://cs.calvin.edu/books/c++/intro/3e/")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/books/c++/ds/2e/")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/books/fortran/")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/books/java/intro/1e/")
    response.should have_selector("loc", :content => "http://cs.calvin.edu/books/networking/labbook/")
  end
end
