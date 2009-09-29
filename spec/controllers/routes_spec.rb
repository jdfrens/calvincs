require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  it "should use home controller as root" do
    route_for(:controller => "home", :action => "index").should == "/"
  end

  it "should map root to home controller" do
    params_from(:get, "/").should == {:controller => "home", :action => "index"}
  end

end

describe PagesController do

  it "should recognize page routes" do
    route_for(:controller => "pages", :action => "show", :id => 'foo').should == "/p/foo"
  end

  it "should generate page routes" do
    params_from(:get, "/p/foobar").should == { :controller => "pages", :action => "show", :id => 'foobar' }
  end

end