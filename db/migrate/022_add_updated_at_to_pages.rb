class AddUpdatedAtToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :updated_at, :datetime
  end

  def self.down
    remove_column :pages, :updated_at
  end
end
