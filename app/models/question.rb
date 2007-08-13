class Question < ActiveRecord::Base
  
  validates_presence_of [:query, :answer, :faq_id]
  
end
