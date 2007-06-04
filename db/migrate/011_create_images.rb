class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :url,     :string
      t.column :caption, :string
      t.column :tag,     :string
    end
  end

  def self.down
    drop_table :images
  end
end
