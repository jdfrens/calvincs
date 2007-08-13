class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.column :query, :text
      t.column :answer, :text
    end
  end

  def self.down
    drop_table :questions
  end
end
