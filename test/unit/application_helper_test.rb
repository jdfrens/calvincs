require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase

  def setup
    @helper = Object.new
    @helper.extend(ApplicationHelper)
  end
  
  def test_link_to_static
    assert_equal '<a href="http://www.calvin.edu/">text</a>',
      @helper.link_to_static(:calvin, 'text'), ':calvin has a static link'
    assert_equal '<a href="http://www.calvin.edu/">Calvin College</a>',
      @helper.link_to_static(:calvin), 'default text works'
  end
  
  def test_link_to_static_raises_exceptions
    assert_raise(RuntimeError) { @helper.link_to_static :invalid }
  end

  def test_link_to_static_raises_exceptions2
    assert_raise(RuntimeError) { @helper.link_to_static :url_only }
  end
  
end