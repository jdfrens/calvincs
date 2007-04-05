class AddGoLiveAtToNewsItems < ActiveRecord::Migration
  def self.up
    add_column :news_items, :goes_live_at, :timestamp
    NewsItem.find(:all).each do |news_item|
      news_item.goes_live_at = 1.day.ago
      news_item.save!
    end
  end

  def self.down
    remove_column :news_items, :goes_live_at
  end
end
