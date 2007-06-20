require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < Test::Unit::TestCase

  fixtures :images, :image_tags

  def test_verification
    image = Image.new
    assert !image.valid?
    assert image.errors.invalid?(:url)
    assert image.errors.invalid?(:caption)
  end
  
  def test_initialize_with_tags_string
    params = { :url => 'somewhere', 
               :caption => 'something',
               :tags_string => 'tag1 tag2 tag3' }
    image = Image.create!(params)
    assert_equal "somewhere", image.url
    assert_equal "something", image.caption
    assert_equal "", image.tags_string
    
    image.tags_string = params[:tags_string]
    image.save!
    image.reload
    assert_equal "tag1 tag2 tag3", image.tags_string
  end
  
  def test_render_caption
    assert_equal "Somebody works on our *mission*.",
        images(:mission).caption
    assert_equal "Somebody works on our <strong>mission</strong>.",
        images(:mission).render_caption
    
    assert_nil images(:jeremy_faculty).caption
    assert_equal "", images(:jeremy_faculty).render_caption
  end
  
  def test_tags
    assert_equal [], images(:alphabet).tags
    assert_equal ['mission'], images(:mission).tags
    assert_equal ['mission', 'another'].to_set, images(:mission2).tags.to_set    
  end
  
  def test_tags_string
    assert_equal '', images(:alphabet).tags_string
    assert_equal 'mission', images(:mission).tags_string
    assert_equal 'mission another', images(:mission2).tags_string
  end

  def test_set_tags_string
    image = images(:mission2)
    assert_equal 'mission another', images(:mission2).tags_string

    image.tags_string = 'mission another foobar'
    image.reload
    assert_equal 'mission another foobar', image.tags_string
    assert_equal ['mission', 'another', 'foobar'].to_set, image.tags.to_set
    
    image.tags_string = 'mission foobar'
    image.reload
    assert_equal 'mission foobar', image.tags_string
    assert_equal ['mission', 'foobar'].to_set, image.tags.to_set
  end
end
