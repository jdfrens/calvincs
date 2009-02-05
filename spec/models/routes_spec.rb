require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RoutesTest < Test::Unit::TestCase

  should "use home controller as root" do
    assert_recognizes({ :controller => "home", :action => "index" }, "/")
    assert_generates("/", :controller => "home", :action => "index")
  end

  context "page routes" do
    should "recognize page routes" do
      assert_recognizes(
        { :controller => "page", :action => "view", :id => 'foo'},
        "/p/foo"
      )
      assert_recognizes(
        { :controller => "page", :action => "view", :id => 'foobar'},
        "/p/foobar"
      )
      assert_recognizes(
        { :controller => "page", :action => "view", :id => 'foo_bar'},
        "/p/foo_bar"
      )      
    end

    should "generate page routes" do
      assert_generates(
        "/p/foo",
        { :controller => "page", :action => "view", :id => 'foo'}
      )
      assert_generates(
        "/p/foobar",
        { :controller => "page", :action => "view", :id => 'foobar'}
      )
      assert_generates(
        "/p/foo_bar",
        { :controller => "page", :action => "view", :id => 'foo_bar'}
      )
    end
  end
  
end
