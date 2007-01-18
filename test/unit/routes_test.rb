require File.dirname(__FILE__) + '/../test_helper'

class RoutesTest < Test::Unit::TestCase

  should "find default route" do
    assert_recognizes({ :controller => "home", :action => "index" }, "/")
  end
  
end