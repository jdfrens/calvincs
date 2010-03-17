class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table "newsitems", :force => true do |t|
      t.string   "headline"
      t.string   "teaser"
      t.text     "content"
      t.integer  "user_id"
      t.datetime "goes_live_at"
      t.datetime "expires_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :news_items
  end
end
