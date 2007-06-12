require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages, :images, :image_tags

  def test_fail_to_inialize_with_duplicate_identifier
    page = Page.new(
      :identifier => 'mission_statement', :content => 'something'
    )
    assert !page.valid?
  end

  def test_allow_underscores_in_identifier
    page = Page.new(
        :identifier => '_underscores_are_okay_', :title => 'Good',
        :content => 'something'
    )
    assert page.valid?
  end
      
  def test_invalid_identifiers
    page = Page.new(
        :identifier => '  whitespacey  ', :title => 'Good',
        :content => 'something'
    )
    assert !page.valid?
    assert_equal 'should be like a Java identifier',
        page.errors[:identifier]
    
    page = Page.new(
        :identifier => 'punc-tu-ation', :title => 'Good',
        :content => 'something'
    )
    assert !page.valid?
  end
  
  def test_fail_to_initialize_without_title
    page = Page.new(
        :identifier => 'okay', :title => '', :content => 'something'
    )
    assert !page.valid?
    assert_equal "can't be blank", page.errors[:title]
  end
  
  def test_fail_to_initialize_without_content
    page = Page.new(
        :identifier => 'okay', :title => 'Valid Title', :content => ''
    )
    assert !page.valid?
    assert_equal "can't be blank", page.errors[:content]
  end
  
  def test_render_content
    assert_equal "<p>We state <strong>our</strong> mission.</p>",
        pages(:mission_statement).render_content
    assert_equal "<p>a b c d e f g <em>h i j k</em></p>",
        pages(:alphabet).render_content
    assert_equal "<p>home page text written in <strong>textile</strong></p>",
        pages(:home_page).render_content
  end
  
  def test_images
    assert_equal [images(:mission_statement_image), images(:mission_statement_image2)],
        pages(:mission_statement).images
  end
  
  def test_random_image
    assert_equal images(:mission_statement_image), pages(:mission_statement).random_image(0)
    assert_equal images(:mission_statement_image2), pages(:mission_statement).random_image(1)
    5.times do |i|
      assert [images(:mission_statement_image), images(:mission_statement_image2)].include?(pages(:mission_statement).random_image)
    end
  end
  
end
