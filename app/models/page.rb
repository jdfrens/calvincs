class Page < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :content
  validates_uniqueness_of :identifier
  validates_format_of :identifier, :with => /^(\w|_)+$/,
      :message => 'should be like a Java identifier'
  
  def render_content
    RedCloth.new(content).to_html
  end
  
  def render_content_lite
    RedCloth.new(content, [:lite_mode]).to_html
  end
  
  def random_image(index=-1)
    Image.pick_random(identifier, index)
  end
  
end
