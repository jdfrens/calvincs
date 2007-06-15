class Degree < ActiveRecord::Base

  validates_presence_of :user_id, :degree_type, :institution, :year
  validates_numericality_of :year
  
end
