# == Schema Information
# Schema version: 20100315182611
#
# Table name: images
#
#  id      :integer         not null, primary key
#  url     :string(255)
#  caption :text(255)
#  width   :integer
#  height  :integer
#

require 'spec_helper'

describe Image do

  fixtures :images, :image_tags

  it "should do verifications" do
    image = Image.new
    assert !image.valid?
    assert image.errors[:url].any?
  end

  it "should get dimension info" do
    image_info = mock("image info", :width => 8, :height => 32)

    ImageInfo.should_receive(:new).with("http://example.com/somewhere.gif").and_return(image_info)

    image = Image.create(:url => "http://example.com/somewhere.gif")

    image.width.should == 8
    image.height.should == 32
  end

  it "should refresh dimensions" do
    images = [mock_model(Image), mock_model(Image), mock_model(Image)]

    Image.should_receive(:all).and_return(images)
    images[0].should_receive(:obtain_dimensions)
    images[0].should_receive(:save!)
    images[1].should_receive(:obtain_dimensions)
    images[1].should_receive(:save!)
    images[2].should_receive(:obtain_dimensions)
    images[2].should_receive(:save!)

    Image.refresh_dimensions!
  end

  it "should handle 404 gracefully" do
    image = Image.new(:url => "http://www.example.com/foobar.jpg")
    image.obtain_dimensions

    image.usability.should == :unusable
  end

  context "usability based on dimensions" do
    it "should be wide" do
      images(:mission_wide).usability.should == :wide
    end

    it "should be narrow" do
      images(:mission_narrow).usability.should == :narrow
    end

    it "should be square" do
      images(:alphabet).usability.should == :square
    end

    it "should be a headshot" do
      images(:jeremy_headshot).usability.should == :headshot
    end

    it "should be a headshot even if tall" do
      images(:tall_headshot).usability.should == :headshot
    end
    
    it "should be a homepage splash" do
      images(:homepage).usability.should == :homepage
    end

    it "should be unusable" do
      images(:jeremy_in_action).usability.should == :unusable
    end
  end

  def test_tagging
    assert_equal "", images(:alphabet).tags_string
    assert_equal "mission mission_wide", images(:mission_wide).tags_string
    assert_equal "mission mission_narrow", images(:mission_narrow).tags_string

    alphabet = images(:alphabet)
    alphabet.tags_string = "foo bar"
    alphabet.reload
    assert_equal "foo bar", alphabet.tags_string
    assert_equal alphabet, ImageTag.find_by_tag("foo").image
    assert_equal alphabet, ImageTag.find_by_tag("bar").image

    mission2 = images(:mission_narrow)
    mission2.tags_string = ""
    mission2.reload
    assert_equal "", mission2.tags_string
    assert_nil ImageTag.find_by_tag("another")
  end

  def test_pick_random_image
    counts = { images(:mission_wide) => 0, images(:mission_narrow) =>  0 }
    100.times do
      image = Image.pick_random("mission")
      counts[image] = counts[image] + 1
    end
    assert counts[images(:mission_wide)] > 0
    assert counts[images(:mission_narrow)] > 0
  end

  def test_pick_random_image_for_nonexistant_tag
    assert_nil Image.pick_random("does_not_exist")
  end

  def test_tags
    assert_equal [], images(:alphabet).tags
    assert_equal ['mission', 'mission_wide'], images(:mission_wide).tags
    assert_equal ['mission', 'mission_narrow'].to_set, images(:mission_narrow).tags.to_set
  end

  def test_tags_string
    assert_equal '', images(:alphabet).tags_string
    assert_equal 'mission mission_wide', images(:mission_wide).tags_string
    assert_equal 'mission mission_narrow', images(:mission_narrow).tags_string
  end

  def test_set_tags_string
    image = images(:mission_narrow)
    assert_equal 'mission mission_narrow', images(:mission_narrow).tags_string

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
