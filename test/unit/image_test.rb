require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < Test::Unit::TestCase

  fixtures :images, :image_tags

  def test_verification
    image = Image.new
    assert !image.valid?
    assert image.errors.invalid?(:url)
  end
  
  def test_setting_width_and_height
    ImageInfo.fake_size("somewhere", :width => 123, :height => 665)
    ImageInfo.fake_size("somewhereelse", :width => 8, :height => 32)
    
    image = Image.new(:url => "somewhere")
    image.save!
    assert_equal 123, image.width
    assert_equal 665, image.height
    
    image = Image.new(:url => "somewhereelse")
    image.save!
    assert_equal 8, image.width
    assert_equal 32, image.height
  end
  
  def test_tagging
    assert_equal "", images(:alphabet).tags_string
    assert_equal "mission", images(:mission).tags_string
    assert_equal "mission another", images(:mission2).tags_string
    
    alphabet = images(:alphabet)
    alphabet.tags_string = "foo bar"
    alphabet.reload
    assert_equal "foo bar", alphabet.tags_string
    assert_equal alphabet, ImageTag.find_by_tag("foo").image
    assert_equal alphabet, ImageTag.find_by_tag("bar").image
    
    mission2 = images(:mission2)
    mission2.tags_string = ""
    mission2.reload
    assert_equal "", mission2.tags_string
    assert_nil ImageTag.find_by_tag("another")
  end
  
  def test_pick_random_image
    counts = { images(:mission) => 0, images(:mission2) =>  0 }
    100.times do
      image = Image.pick_random("mission")
      counts[image] = counts[image] + 1
    end
    assert counts[images(:mission)] > 0
    assert counts[images(:mission2)] > 0
  end
  
  def test_pick_random_image_for_nonexistant_tag
    assert_nil Image.pick_random("does_not_exist")
  end
  
  def test_render_caption
    assert_equal "Somebody works on our *mission*.",
        images(:mission).caption
    assert_equal "Somebody works on our <strong>mission</strong>.",
        images(:mission).render_caption
    
    assert_nil images(:jeremy_headshot).caption
    assert_equal "", images(:jeremy_headshot).render_caption
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
