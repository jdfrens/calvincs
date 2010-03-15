class AddUrlToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :url, :string
  end

  def self.down
    drop_column :courses, :url
  end
end
