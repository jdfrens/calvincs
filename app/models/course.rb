# == Schema Information
# Schema version: 20090905181738
#
# Table name: courses
#
#  id          :integer         not null, primary key
#  department  :string(255)
#  number      :integer
#  credits     :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime
#

class Course < ActiveRecord::Base

  validates_presence_of :department, :number, :title, :credits

  validates_format_of :department, :with => /^[A-Z]{2,5}$/,
      :message => 'should be two to five capital letters'
  validates_numericality_of :number, :only_integer => true
  validates_uniqueness_of :number, :scope => 'department'
  validates_numericality_of :credits, :only_integer => true
  
  def identifier
    department + ' ' + number.to_s
  end

end
