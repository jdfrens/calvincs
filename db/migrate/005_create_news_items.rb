class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.column :title, :string
      t.column :content, :text
      t.column :user_id, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :expires_at, :timestamp
    end
  end

  def self.down
    drop_table :news_items
  end
end
