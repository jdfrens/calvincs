class ImageTag < ActiveRecord::Base

  belongs_to :image
  
  validates_presence_of :image_id
  
end
