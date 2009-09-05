class RenameLabelOfCourse < ActiveRecord::Migration
  def self.up
    rename_column :courses, :label, :department
  end

  def self.down
    rename_column :courses, :department, :label
  end
end
