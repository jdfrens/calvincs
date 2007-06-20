require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :degrees, :images, :image_tags
  user_fixtures
  
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
  
  def test_full_name
    assert_equal "Jeremy D.", users(:jeremy).first_name
    assert_equal "Frens", users(:jeremy).last_name
    assert_equal "Jeremy D. Frens", users(:jeremy).full_name
    assert_equal "Joel C. Adams", users(:joel).full_name
    assert_equal "Keith Vander Linden", users(:keith).full_name
  end

  def test_image
    assert_equal images(:jeremy_faculty), users(:jeremy).image
    assert_equal images(:keith_faculty), users(:keith).image
    assert_nil users(:sharon).image
  end
end
