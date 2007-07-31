class Image < ActiveRecord::Base

  has_many :image_tags, :dependent => :delete_all

  before_validation :obtain_dimensions
  validates_presence_of :url
  
  attr_accessible :url, :width, :height, :caption
  
  def self.pick_random(tag, index=-1)
    images = ImageTag.find_all_by_tag(tag).map(&:image)
    if index == -1
      index = rand(images.size)
    end
    images[index]
  end

  def render_caption
    if caption
      RedCloth.new(caption, [:lite_mode]).to_html
    else
      ""
    end
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
  
  def obtain_dimensions
    if url
      info = ImageInfo.new(self.url)
      self.width = info.width
      self.height = info.height
    end
  end
  
end
