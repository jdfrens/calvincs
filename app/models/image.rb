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

class Image < ActiveRecord::Base

  has_many :image_tags, :dependent => :delete_all

  before_validation :obtain_dimensions
  validates_presence_of :url

  attr_accessible :url, :width, :height, :caption

  def self.pick_random(tag, index = nil)
    images = ImageTag.where(:tag => tag).includes(:image).map(&:image)
    index ||= rand(images.size)
    images[index]
  end

  def self.refresh_dimensions!
    all.each do |image|
      image.obtain_dimensions
      image.save!
    end
  end  

  def tags
    image_tags.map { |object| object.tag }
  end

  def tags_string
    tags.join(' ')
  end

  def tags_string=(string)
    if string.nil?
      string = ""
    end
    image_tags.delete_all
    string.split(/\s+/).each do |new_tag|
      image_tags.create!(:tag => new_tag)
    end
  end

  def usability
    if wide?
      :wide
    elsif narrow?
      :narrow
    elsif square?
      :square
    elsif headshot?
      :headshot
    elsif homepage?
      :homepage
    else
      :unusable
    end
  end

  def wide?
    check_fudged_dimensions(265, 200)
  end

  def narrow?
    check_fudged_dimensions(200, 265)
  end

  def square?
    check_fudged_dimensions(265, 265)
  end

  def headshot?
    check_fudged_dimensions(150, 200) || check_fudged_dimensions(150, 225)
  end

  def homepage?
    check_fudged_dimensions(680, 240)
  end

  def obtain_dimensions
    if url && url =~ /^http:/
      info = ImageInfo.new(self.url)
      self.width = info.width
      self.height = info.height
    end
  rescue OpenURI::HTTPError
    # we won't worry about it
  end

  private
  def check_fudged_dimensions(ideal_width, ideal_height)
    check_fudged_dimension(ideal_width, width) && check_fudged_dimension(ideal_height, height)
  end

  def check_fudged_dimension(ideal, actual)
    ((ideal-5)..(ideal+5)).include?(actual)
  end
end
