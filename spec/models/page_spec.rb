require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
  
  def test_last_updated_dates
    assert_equal [pages(:mission).updated_at], pages(:mission).last_updated_dates
    assert_equal [pages(:alphabet).updated_at], pages(:alphabet).last_updated_dates
    assert_equal [pages(:home_page).updated_at], pages(:home_page).last_updated_dates
  end
    
  def test_random_image
    assert_equal images(:mission_wide), pages(:mission).random_image(0)
    assert_equal images(:mission_narrow), pages(:mission).random_image(1)
    5.times do |i|
      assert [images(:mission_wide), images(:mission_narrow)].include?(pages(:mission).random_image)
    end
  end
  
  def test_url_to
    assert_equal "/p/mission", pages(:mission).url_to
    assert_equal "/p/_jeremy_interests", pages(:jeremy_interests).url_to
  end
  
  def test_subpage_huh
    assert !pages(:mission).subpage?
    assert  pages(:home_page).subpage?
  end
  
end
