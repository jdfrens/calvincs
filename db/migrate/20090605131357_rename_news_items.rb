class RenameNewsItems < ActiveRecord::Migration
  def self.up
    rename_table :news_items, :newsitems
  end

  def self.down
    rename_table :newsitems, :news_items
  end
end
