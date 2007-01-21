class Course < ActiveRecord::Base

  validates_presence_of :label, :number, :title, :credits

  validates_format_of :label, :with => /^[A-Z]{2,5}$/,
      :message => 'should be two to five capital letters'
  validates_numericality_of :number, :only_integer => true
  validates_uniqueness_of :number, :scope => 'label'
  validates_numericality_of :credits, :only_integer => true
  
  def identifier
    label + ' ' + number.to_s
  end

end
