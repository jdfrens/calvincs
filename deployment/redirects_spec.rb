require 'uri'
require 'net/http'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  config.include RedirectHelpers
end

describe "redirections of the Calvin CS website" do

  context "moved pages" do
    it "should redirect curriculum pages" do
      get("/curriculum/bcs.php").should redirect_to("/p/bcs")
      get("/curriculum/bacs.php").should redirect_to("/p/bacs")
      get("/curriculum/bais.php").should redirect_to("/p/bais")
      get("/curriculum/bada.php").should redirect_to("/p/bada")
    end

    it "should redirect faculty page" do
      get("/faculty/index.php").should redirect_to("/personnel/list")
      get("/faculty/").should redirect_to("/personnel/list/")
    end

    it "should redirect scholarship page" do
      get("/activities/scholarship.php").should redirect_to("/p/scholarship")
      get("/a/scholarship.php").should redirect_to("/p/scholarship")
    end
  end

  context "activities" do
    it "should redirect activies landing page" do
      get("/activities/index.php").should redirect_to("/p/research")
      get("/activities/").should redirect_to("/p/research")
      get("/a/index.php").should redirect_to("/p/research")
      get("/a/").should redirect_to("/p/research")
    end

    it "should redirect alice" do
      get("/activities/alice").should redirect_to("http://alice.calvin.edu/")
    end

    it "should redirect basted" do
      get("/activities/blasted/").should be_success
      get("/a/blasted/").should be_success
    end

    it "should redirect books" do
      get("/activities/books/").should be_success
      get("/a/books/").should be_success
    end

    context "networking book does its own redirecting" do
      it "should succeed networking book" do
        get("/activities/books/networking/").should be_success
        get("/a/books/networking/").should be_success
        get("/books/networking/").should be_success
      end
    end

    it "should redirect Project Connect" do
      get("/activities/connect/index.php").should redirect_to("/p/connect")
    end

    it "should redirect consulting" do
      get("/activities/consulting/").should be_success
      get("/a/consulting/").should be_success
    end

    it "should redirect very old GLSEC urls" do
      get("/activities/isv").should redirect_to("http://www.glsec.org/")
      get("/a/isv").should redirect_to("http://www.glsec.org/")
      get("/isv").should redirect_to("http://www.glsec.org/")
    end

    it "should have a sestudy" do
      get("/activities/sestudy/").should be_success
      get("/a/sestudy/").should be_success
      get("/sestudy/").should be_success
    end

    it "should have softball schedules" do
      get("/activities/softball/").should be_success
      get("/a/softball/").should be_success
      get("/softball/").should be_success
    end
  end

  it "should have administrative folders" do
    get("/administrative/").should be_success
  end

  it "should have department folders" do
    get("/department/").should be_unauthorized
  end
end
