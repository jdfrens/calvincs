# == Schema Information
# Schema version: 20100315182611
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  identifier :string(255)
#  content    :text
#  title      :string(255)
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  fixtures :pages, :images, :image_tags

  describe "named scopes" do
    it "should find normal pages" do
      Page.normal_pages.should include(pages(:mission))
      Page.normal_pages.should include(pages(:alphabet))
      Page.normal_pages.should_not include(pages(:jeremy_interests))
      Page.normal_pages.should_not include(pages(:jeremy_profile))
      Page.normal_pages.should_not include(pages(:jeremy_status))
    end

    it "should find subpages" do
      Page.subpages.should_not include(pages(:mission))
      Page.subpages.should_not include(pages(:alphabet))
      Page.subpages.should include(pages(:jeremy_interests))
      Page.subpages.should include(pages(:jeremy_profile))
      Page.subpages.should include(pages(:jeremy_status))
    end
  end

  describe "validation issues" do
    it "should insist on unique identifier" do
      page = Page.new(
              :identifier => 'mission_statement', :content => 'something'
      )
      page.should_not be_valid
    end

    it "should allow underscores in identifier" do
      page = Page.new(
              :identifier => '_underscores_are_okay_', :title => 'Good',
                      :content => 'something'
      )
      assert page.valid?
    end

    it "should not allow whitespace in identifiers" do
      page = Page.new(
              :identifier => '  whitespacey  ', :title => 'Good',
                      :content => 'something'
      )
      page.should_not be_valid
      assert_equal 'should be like a Java identifier',
              page.errors[:identifier]
    end

    it "should not allow punctuation in identifiers" do
      page = Page.new(
              :identifier => 'punc-tu-ation', :title => 'Good',
                      :content => 'something'
      )
      page.should_not be_valid
    end

    def test_fail_to_initialize_without_title
      page = Page.new(
              :identifier => 'okay', :title => '', :content => 'something'
      )
      page.should_not be_valid
      assert_equal "can't be blank", page.errors[:title]
    end

    def test_fail_to_initialize_without_content
      page = Page.new(
              :identifier => 'okay', :title => 'Valid Title', :content => ''
      )
      page.should_not be_valid
      assert_equal "can't be blank", page.errors[:content]
    end
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

  def test_subpage_huh
    assert !pages(:mission).subpage?
    assert  pages(:home_page).subpage?
  end

end
