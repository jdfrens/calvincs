class CreateImageTags < ActiveRecord::Migration
  def self.up
    create_table :image_tags do |t|
      t.column :image_id, :integer
      t.column :tag, :string
    end
  end

  def self.down
    drop_table :image_tags
  end
end
