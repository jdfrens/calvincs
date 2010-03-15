# == Schema Information
# Schema version: 20100315182611
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  query      :text
#  answer     :text
#  faq_id     :integer
#  position   :integer
#  updated_at :datetime
#

class Question < ActiveRecord::Base

  belongs_to :faq
  acts_as_list :scope => :faq
  
  validates_presence_of [:query, :answer, :faq_id]
  
end
