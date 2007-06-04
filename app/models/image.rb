class Image < ActiveRecord::Base

  validates_presence_of :url, :caption, :tag
  
end
