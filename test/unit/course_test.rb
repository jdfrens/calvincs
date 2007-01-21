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
  
  should "have a whole variety of problems with label validation" do
    course = Course.find(3)
    assert course.valid?
    course.label = 'C'
    assert !course.valid?, 'label should be longer than one character'
    assert_equal 'should be two to five capital letters', course.errors[:label]
    course.label = 'CS'
    assert course.valid?
    course.label = ' CS '
    assert !course.valid?, 'label should not have whitespace'
    course.label = 'CS'
    assert course.valid?
    course.label = 'CS1'
    assert !course.valid?, 'label should not have non-alphabetic characters'
    course.label = 'CS'
    assert course.valid?
    course.label = 'CS!'
    assert !course.valid?, 'label should not have non-alphabetic characters'
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
  
  should "get identifier of course" do
    assert_equal 'CS 108', Course.find(3).identifier
    assert_equal 'CS 214', Course.find(1).identifier
    assert_equal 'IS 337', Course.find(2).identifier
  end

end
