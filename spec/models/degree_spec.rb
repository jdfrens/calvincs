require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class DegreeTest < ActiveRecord::TestCase

  fixtures :degrees, :users
  
  def test_validations_of_presence
    assert_invalid Degree.new, [:user_id, :degree_type, :institution, :year]
  end
  
  def test_bad_initialization_errors
    degree = Degree.new :year => 'foobar'
 
    assert !degree.valid? 
    assert degree.errors.invalid?(:year)
  end

end
