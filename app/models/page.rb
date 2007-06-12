class Page < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :content
  validates_uniqueness_of :identifier
  validates_format_of :identifier, :with => /^(\w|_)+$/,
      :message => 'should be like a Java identifier'
  
  def render_content
    RedCloth.new(content).to_html
  end
  
  def images
    ImageTag.find_all_by_tag(identifier).map { |image_tag| image_tag.image }
  end
  
  def random_image(index=-1)
    if index == -1
      index = rand(images.size)
    end
    images[index]
  end
  
end
