class MoveImageTagToImageTags < ActiveRecord::Migration
  def self.up
    Image.find(:all).each do |image|
      image.image_tags.create!(:tag => image.tag)
      image.save!
    end
    
    remove_column :images, :tag
  end

  def self.down
    add_column :images, :tag, :string
    
    Image.find(:all).each do |image|
      image.tag = image.tags.first
      image.save!
    end
  end
end
