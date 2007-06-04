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
  
end
