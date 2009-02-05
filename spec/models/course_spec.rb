require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CourseTest < Test::Unit::TestCase
  fixtures :courses

  def test_initialize_validations
    course = Course.new
    assert !course.valid?
    assert course.errors.invalid?(:label)
    assert course.errors.invalid?(:number)
    assert course.errors.invalid?(:title)
    assert course.errors.invalid?(:credits)
  end
  
  def test_initialize_bad_data_validations
    course = Course.new(
      :label => 'C', :number => 'bad', :title => 'okay', :credits => 'iv'
      )
    assert !course.valid?
    assert course.errors.invalid?(:label)
    assert course.errors.invalid?(:number)
    assert !course.errors.invalid?(:title)
    assert course.errors.invalid?(:credits)
  end
  
  def test_extensive_label_validations
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
  
  def test_fail_on_duplicate_course
    course = Course.new(
      :label => 'CS', :number => '108', :title => 'Duplicate!', :credits => 3
    )
    assert !course.valid?
    assert !course.errors.invalid?(:label)
    assert course.errors.invalid?(:number)
    assert !course.errors.invalid?(:title)
    assert !course.errors.invalid?(:credits)
  
    course = Course.new(
      :label => 'IS', :number => '108',
      :title => 'IS in the Middle Ages', :credits => 3
    )
    assert course.valid?, "reusing a number should be okay"
  end
  
  def test_identifier
    assert_equal 'CS 108', Course.find(3).identifier
    assert_equal 'CS 214', Course.find(1).identifier
    assert_equal 'IS 337', Course.find(2).identifier
  end

end
