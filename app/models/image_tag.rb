# == Schema Information
# Schema version: 20100315182611
#
# Table name: image_tags
#
#  id       :integer         not null, primary key
#  image_id :integer
#  tag      :string(255)
#

class ImageTag < ActiveRecord::Base

  belongs_to :image
  
  validates_presence_of :image_id
  
end
