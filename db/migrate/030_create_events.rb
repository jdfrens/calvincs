class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      # inheritance for colloquia and conferences
      t.column :type, :string
      
      # common attributes
      t.column :title, :string
      t.column :subtitle, :string
      t.column :description, :text
      t.column :start, :datetime
      t.column :length, :integer
    end
  end

  def self.down
    drop_table :events
  end
end
