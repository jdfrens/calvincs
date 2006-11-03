require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase

  def setup
    @helper = Object.new
    @helper.extend(ApplicationHelper)
  end
  
  should "link to static pages" do
    assert_equal '<a href="http://www.calvin.edu/">text</a>',
      @helper.link_to_static(:calvin, 'text'), ':calvin has a static link'
    assert_equal '<a href="http://www.calvin.edu/">Calvin College</a>',
      @helper.link_to_static(:calvin), 'default text works'
  end
  
  should "raise exception when link_to_static given invalid keyword" do  
    assert_raise(RuntimeError) { @helper.link_to_static :invalid }
  end

  should "raise exception when link_to_static given invalid keyword for link name" do  
    assert_raise(RuntimeError) { @helper.link_to_static :url_only }
  end
    
end