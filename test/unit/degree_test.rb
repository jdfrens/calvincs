require File.dirname(__FILE__) + '/../test_helper'

class DegreeTest < Test::Unit::TestCase

  fixtures :degrees, :users
  
  def test_missing_initialization_errors
    degree = Degree.new
    
    assert !degree.valid? 
    assert degree.errors.invalid?(:user_id)
    assert degree.errors.invalid?(:degree_type)
    assert degree.errors.invalid?(:institution)
    assert degree.errors.invalid?(:year)
  end
  
  def test_bad_initialization_errors
    degree = Degree.new :year => 'foobar'
 
    assert !degree.valid? 
    assert degree.errors.invalid?(:year)
  end

end
