class AddUpdatedAtToFaqsAndQuestions < ActiveRecord::Migration
  def self.up
    add_column :faqs, :updated_at, :datetime
    add_column :questions, :updated_at, :datetime
    
    Faq.reset_column_information
    Faq.find(:all).each do |faq|
      faq.updated_at = Time.now
      faq.save!
    end
    Question.reset_column_information
    Question.find(:all).each do |question|
      question.updated_at = Time.now
      question.save!
    end
  end

  def self.down
    remove_column :faqs, :updated_at
    remove_column :questions, :updated_at
  end
end
