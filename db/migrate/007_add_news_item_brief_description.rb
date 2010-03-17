class AddNewsItemBriefDescription < ActiveRecord::Migration
  def self.up
    add_column :news_items, :brief_description, :string, :default => ""
  end

  def self.down
    remove_column :news_items, :brief_description
  end
end
