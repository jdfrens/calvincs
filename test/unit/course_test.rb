require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < Test::Unit::TestCase
  fixtures :courses

  should "complain when constructed without required data" do
    course = Course.new
    assert !course.valid?
    assert course.errors.invalid?(:label)
    assert course.errors.invalid?(:number)
    assert course.errors.invalid?(:title)
    assert course.errors.invalid?(:credits)
  end
  
  should "complain when constructed with bad data" do
    course = Course.new(
      :label => 'C', :number => 'bad', :title => 'okay', :credits => 'iv'
      )
    assert !course.valid?
    assert course.errors.invalid?(:label)
    assert course.errors.invalid?(:number)
    assert !course.errors.invalid?(:title)
    assert course.errors.invalid?(:credits)
  end
  
  should "complain when duplicate course created" do
    course = Course.new(
      :label => 'CS', :number => '108', :title => 'Duplicate!', :credits => 3
    )
    assert !course.valid?
    assert !course.errors.invalid?(:label)
    assert course.errors.invalid?(:number)
    assert !course.errors.invalid?(:title)
    assert !course.errors.invalid?(:credits)
  end
  
  should "create duplicate number with different label" do
    course = Course.new(
      :label => 'IS', :number => '108',
      :title => 'IS in the Middle Ages', :credits => 3
    )
    assert course.valid?
  end
  
  
end
