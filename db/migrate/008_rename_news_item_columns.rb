class RenameNewsItemColumns < ActiveRecord::Migration
  def self.up
    rename_column :news_items, :title, :headline
    rename_column :news_items, :brief_description, :teaser
  end

  def self.down
    rename_column :news_items, :headline, :title
    rename_column :news_items, :teaser, :brief_description
  end
end
