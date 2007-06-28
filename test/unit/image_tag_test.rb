require File.dirname(__FILE__) + '/../test_helper'

class ImageTagTest < Test::Unit::TestCase

  fixtures :image_tags, :images

  def test_validations
    tag = ImageTag.new
    assert !tag.valid?
    assert tag.errors.invalid?(:image_id)
  end
  
  def test_belongs_to_image
    assert_equal images(:mission), image_tags(:mission).image
    assert_equal images(:mission2), image_tags(:mission2).image
    assert_equal images(:mission2), image_tags(:another).image
  end

end
