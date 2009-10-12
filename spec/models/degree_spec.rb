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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class DegreeTest < ActiveRecord::TestCase

  fixtures :degrees, :users
  
  def test_validations_of_presence
    degree = Degree.new
    degree.should be_invalid
    degree.attributes = {:user_id => users(:jeremy), :degree_type => "BCS",
                         :institution => "Hard Knocks", :year => 1666 }
    degree.should be_valid
  end
  
  def test_bad_initialization_errors
    degree = Degree.new :year => 'foobar'
 
    degree.should be_invalid
    degree.errors.should be_invalid(:year)
  end

end
