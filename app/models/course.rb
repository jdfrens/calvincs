class Course < ActiveRecord::Base

  validates_presence_of :label, :number, :title, :credits

  validates_length_of   :label, :in => 2..6
  validates_numericality_of :number, :only_integer => true
  validates_numericality_of :credits, :only_integer => true

end
