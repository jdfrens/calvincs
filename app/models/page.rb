class Page < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :content
  validates_uniqueness_of :identifier
  validates_format_of :identifier, :with => /^(\w|_)+$/,
      :message => 'should be like a Java identifier'
  
  def render_content
    RedCloth.new(content).to_html
  end
  
end
