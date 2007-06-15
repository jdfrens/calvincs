class CreateDegrees < ActiveRecord::Migration
  def self.up
    create_table :degrees do |t|
      t.column :user_id,     :integer
      t.column :type,        :string
      t.column :institution, :string
      t.column :url,         :string
      t.column :year,        :integer
    end
  end

  def self.down
    drop_table :degrees
  end
end
