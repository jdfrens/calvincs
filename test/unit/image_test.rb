require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < Test::Unit::TestCase

  fixtures :images

  def test_verification
    image = Image.new
    assert !image.valid?
    assert image.errors.invalid?(:url)
    assert image.errors.invalid?(:caption)
  end
  
  def test_initialize_with_tags_string
    params = { :url => 'somewhere', :caption => 'something', :tags_string => 'tag1 tag2 tag3' }
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
    image = images(:mission_statement_image)
    assert_equal "Somebody works on our *mission*.", image.caption
    assert_equal "Somebody works on our <strong>mission</strong>.", image.render_caption
  end
  
  def test_tags
    assert_equal [], images(:alphabet_image).tags
    assert_equal ['mission_statement'], images(:mission_statement_image).tags
    assert_equal ['mission_statement', 'another'].to_set, images(:mission_statement_image2).tags.to_set    
  end
  
  def test_tags_string
    assert_equal '', images(:alphabet_image).tags_string
    assert_equal 'mission_statement', images(:mission_statement_image).tags_string
    assert_equal 'mission_statement another', images(:mission_statement_image2).tags_string
  end

  def test_set_tags_string
    image = images(:mission_statement_image2)
    assert_equal 'mission_statement another', images(:mission_statement_image2).tags_string

    image.tags_string = 'mission_statement another foobar'
    image.reload
    assert_equal 'mission_statement another foobar', image.tags_string
    assert_equal ['mission_statement', 'another', 'foobar'].to_set, image.tags.to_set
    
    image.tags_string = 'mission_statement foobar'
    image.reload
    assert_equal 'mission_statement foobar', image.tags_string
    assert_equal ['mission_statement', 'foobar'].to_set, image.tags.to_set
  end
end
