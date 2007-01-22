class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.column :identifier,     :string
      t.column :content,        :text
    end
  end

  def self.down
    drop_table :documents
  end
end
