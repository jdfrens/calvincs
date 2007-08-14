class Faq < ActiveRecord::Base

  has_many :questions, :order => :position, :dependent => :delete_all
  
  validates_presence_of :title, :identifier
  validates_format_of :identifier, :with => /^[a-zA-Z_]+$/
  
end
