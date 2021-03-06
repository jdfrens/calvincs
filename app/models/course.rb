# == Schema Information
# Schema version: 20100315182611
#
# Table name: courses
#
#  id         :integer         not null, primary key
#  department :string(255)
#  number     :integer
#  title      :string(255)
#  created_at :datetime
#

class Course < ActiveRecord::Base

  validates_presence_of :department, :number, :title

  validates_format_of :department, :with => /^[A-Z]{1,3}$/,
      :message => 'should be one to three capital letters'
  validates_numericality_of :number, :only_integer => true
  validates_uniqueness_of :number, :scope => 'department'

  scope :courses_of, 
    lambda { |department| where(:department => department).order("department, number") }
  scope :cs_courses, courses_of("CS")
  scope :is_courses, courses_of("IS")
  scope :interim_courses, courses_of("W")

  def self.find_by_short_identifier(short_identifier)
    short_identifier =~ /^(\w+?)(\d+)$/
    find_by_department_and_number($1.upcase, $2)
  end

  def identifier
    department + ' ' + number.to_s
  end

  def short_identifier
    department.downcase + number.to_s
  end

  def full_title
    identifier + ": " + title
  end
end
