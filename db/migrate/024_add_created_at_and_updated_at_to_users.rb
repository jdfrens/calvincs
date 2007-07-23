class AddCreatedAtAndUpdatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
    
    User.reset_column_information
    User.find(:all).each do |user|
      user.updated_at = Time.now
      user.save!
    end
  end

  def self.down
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
