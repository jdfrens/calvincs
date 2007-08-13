class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.column :title, :string
      t.column :identifier, :string
    end
    
    add_column :questions, :faq_id, :integer
  end

  def self.down
    remove_column :questions, :faq_id
    
    drop_table :faqs
  end
end
