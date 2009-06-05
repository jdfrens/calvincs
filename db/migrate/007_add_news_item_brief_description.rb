class AddNewsItemBriefDescription < ActiveRecord::Migration
  def self.up
    add_column :news_items, :brief_description, :string
    Newsitem.find(:all).each do |news_item|
      news_item.brief_description = 'Default Teaser'
      news_item.save!
    end
  end

  def self.down
    remove_column :news_items, :brief_description
  end
end
