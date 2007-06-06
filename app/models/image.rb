class Image < ActiveRecord::Base

  validates_presence_of :url, :caption, :tag
  
  def render_caption
    RedCloth.new(caption, [:lite_mode]).to_html
  end
end
