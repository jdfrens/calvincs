class CreateIndexesForVariousTables < ActiveRecord::Migration
  def self.up
    add_index :events, [:start, :stop]
    add_index :image_tags, :tag
    add_index :newsitems, [:goes_live_at, :expires_at]
    add_index :newsitems, [:expires_at, :goes_live_at]
    add_index :pages, :identifier
  end

  def self.down
    remove_index :events, [:start, :stop]
    remove_index :image_tags, :tag
    remove_index :newsitems, [:goes_live_at, :expires_at]
    remove_index :newsitems, [:expires_at, :goes_live_at]
    remove_index :pages, :identifier
  end
end
