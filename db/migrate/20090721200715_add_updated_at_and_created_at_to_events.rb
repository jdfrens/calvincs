class AddUpdatedAtAndCreatedAtToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :updated_at, :datetime
    add_column :events, :created_at, :datetime
  end

  def self.down
    remove_column :events, :updated_at
    remove_column :events, :created_at
  end
end
