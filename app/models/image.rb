# == Schema Information
# Schema version: 20091012011757
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
  
  def self.pick_random(tag, index=-1)
    images = ImageTag.find(:all, :conditions => ["tag = ?", tag]).map(&:image)
    if index == -1
      index = rand(images.size)
    end
    images[index]
  end

  def tags
    image_tags.map { |object| object.tag }
  end
  
  def tags_string
    tags.join(' ')
  end
  
  def tags_string=(string)
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
    else
      :unusable
    end
  end
  
  def wide?
    (260..270).include?(width) && (195..205).include?(height)
  end
  
  def narrow?
    (195..205).include?(width) && (260..270).include?(height)
  end
  
  def square?
    (260..270).include?(width) && (260..270).include?(height)
  end
  
  def headshot?
    (145..155).include?(width) && (195..205).include?(height)
  end
  
  def obtain_dimensions
    if url && url =~ /^http:/
      info = ImageInfo.new(self.url)
      self.width = info.width
      self.height = info.height
    end
  end
  
end
