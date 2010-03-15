class DropCourseCatalog < ActiveRecord::Migration
  def self.up
    remove_column :courses, :credits
    remove_column :courses, :description
  end

  def self.down
    add_column :courses, :description, :text
    add_column :courses, :credit, :integer
  end
end
