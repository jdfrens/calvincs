class DropFaqsAndQuestions < ActiveRecord::Migration
  def self.up
    drop_table :faqs
    drop_table :questions
  end

  def self.down
  end
end
