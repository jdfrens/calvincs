class Faq < ActiveRecord::Base
  
  validates_presence_of :title, :identifier
  validates_format_of :identifier, :with => /^[a-zA-Z_]+$/
  
end
