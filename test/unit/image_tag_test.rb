require File.dirname(__FILE__) + '/../test_helper'

class ImageTagTest < Test::Unit::TestCase

  fixtures :image_tags, :images

  def test_belongs_to_image
    assert_equal images(:mission_statement_image), image_tags(:mission_tag).image
    assert_equal images(:mission_statement_image2), image_tags(:mission_tag2).image
    assert_equal images(:mission_statement_image2), image_tags(:another_tag).image
  end

end
