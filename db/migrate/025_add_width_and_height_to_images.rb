class AddWidthAndHeightToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :width, :integer
    add_column :images, :height, :integer
    
    Image.reset_column_information
    Image.find(:all).each do |image|
      image.width = 0
      image.height = 0
      image.save!
    end
  end

  def self.down
    remove_column :images, :width
    remove_column :images, :height
  end
end
