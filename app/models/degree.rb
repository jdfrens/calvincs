# == Schema Information
# Schema version: 20091012011757
#
# Table name: degrees
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  degree_type :string(255)
#  institution :string(255)
#  url         :string(255)
#  year        :integer
#

class Degree < ActiveRecord::Base

  validates_presence_of :user_id, :degree_type, :institution, :year
  validates_numericality_of :year
  
end
