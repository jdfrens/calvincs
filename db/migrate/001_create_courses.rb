class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.column :label,		:string
      t.column :number,		:integer
      t.column :credits,	:integer
      t.column :description,	:text
      t.column :created_at,	:timestamp
    end
  end

  def self.down
    drop_table :courses
  end
end
