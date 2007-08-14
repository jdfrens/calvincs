class Question < ActiveRecord::Base

  belongs_to :faq
  
  validates_presence_of [:query, :answer, :faq_id]
  
end
