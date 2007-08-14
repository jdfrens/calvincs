class Question < ActiveRecord::Base

  belongs_to :faq
  acts_as_list :scope => :faq
  
  validates_presence_of [:query, :answer, :faq_id]
  
end
