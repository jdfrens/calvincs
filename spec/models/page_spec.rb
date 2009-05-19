require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  fixtures :pages, :images, :image_tags

  describe "finding by id or identifier" do
    it "should find by id" do
      Page.find_by_an_id("5").should == pages(:jeremy_interests)
    end

    it "should find by id (and other text)" do
      Page.find_by_an_id("5-whatever").should == pages(:jeremy_interests)
    end

    it "should find by identifier" do
      Page.find_by_an_id("_jeremy_interests").should == pages(:jeremy_interests)
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

  def test_url_to
    assert_equal "/p/mission", pages(:mission).url_to
    assert_equal "/p/_jeremy_interests", pages(:jeremy_interests).url_to
  end

  def test_subpage_huh
    assert !pages(:mission).subpage?
    assert  pages(:home_page).subpage?
  end

end
