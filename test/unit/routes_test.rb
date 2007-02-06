require File.dirname(__FILE__) + '/../test_helper'

class RoutesTest < Test::Unit::TestCase

  should "find default route" do
    assert_recognizes({ :controller => "home", :action => "index" }, "/")
    assert_generates("/", :controller => "home", :action => "index")
  end
  
  should "have special document-view routes" do
    assert_recognizes(
        { :controller => "document", :action => "view", :id => 'foo'},
        "/d/foo"
    )
    assert_recognizes(
        { :controller => "document", :action => "view", :id => 'foobar'},
        "/d/foobar"
    )
    assert_recognizes(
        { :controller => "document", :action => "view", :id => 'foo_bar'},
        "/d/foo_bar"
    )
    assert_generates(
        "/d/foo",
        { :controller => "document", :action => "view", :id => 'foo'}
    )
    assert_generates(
        "/d/foobar",
        { :controller => "document", :action => "view", :id => 'foobar'}
    )
    assert_generates(        
        "/d/foo_bar",
        { :controller => "document", :action => "view", :id => 'foo_bar'}
    )
  end
  
  
end