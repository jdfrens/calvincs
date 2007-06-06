require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < Test::Unit::TestCase

  fixtures :images

  def test_verification
    image = Image.new
    assert !image.valid?
    assert image.errors.invalid?(:url)
    assert image.errors.invalid?(:caption)
    assert image.errors.invalid?(:tag)
  end
  
  def test_render_caption
    image = images(:mission_statement_image)
    assert_equal "Somebody works on our *mission*.", image.caption
    assert_equal "Somebody works on our <strong>mission</strong>.", image.render_caption
  end
  
end
