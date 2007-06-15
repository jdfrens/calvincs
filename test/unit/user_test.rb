require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :degrees, :users
  
  def test_has_many_degrees
    assert_equal_set [], users(:sharon).degrees
    assert_equal_set [degrees(:keith_central)], users(:keith).degrees
    assert_equal_set [degrees(:jeremy_calvin), degrees(:jeremy_iu)], users(:jeremy).degrees
  end
  
  def test_has_many_degrees_destroys_all
    original_count = Degree.find(:all).size
    
    users(:jeremy).destroy
    
    assert_equal original_count - 2, Degree.find(:all).size
  end
  
end
