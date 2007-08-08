require File.dirname(__FILE__) + '/../test_helper'

class ImageTagTest < Test::Unit::TestCase

  fixtures :image_tags, :images

  def test_validations
    tag = ImageTag.new
    assert !tag.valid?
    assert tag.errors.invalid?(:image_id)
  end
  
  def test_belongs_to_image
    assert_equal images(:mission_wide), image_tags(:for_mission).image
    assert_equal images(:mission_narrow), image_tags(:for_mission2).image
    assert_equal images(:jeremy_in_action), image_tags(:for_jeremy).image
  end
  
end
