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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Course do

  context "validations" do
    it "should complain about no values" do
      course = Course.new
      course.should_not be_valid
      assert !course.valid?
      assert course.errors.invalid?(:department)
      assert course.errors.invalid?(:number)
      assert course.errors.invalid?(:title)
      assert course.errors.invalid?(:credits)
    end

    it "should complain about bad values" do
      course = Course.new(
              :department => 'C', :number => 'bad', :title => 'okay', :credits => 'iv'
      )
      assert !course.valid?
      assert course.errors.invalid?(:department)
      assert course.errors.invalid?(:number)
      assert !course.errors.invalid?(:title)
      assert course.errors.invalid?(:credits)
    end
  end

  context "department validations" do
    before(:each) do
      @course = Course.create!(:department => "CS", :number => 666, :title => "okay", :credits => 4)
    end

    it "should reject single character" do
      @course.department = 'C'
      @course.should_not be_valid
      @course.errors[:department].should == 'should be two to five capital letters'
    end

    it "should reject whitespace" do
      @course.department = ' CS '
      @course.should_not be_valid
    end

    it "should reject numbers" do
      @course.department = 'CS1'
      @course.should_not be_valid
    end

    it "should reject punctuation" do
      @course.department = 'CS!'
      @course.should_not be_valid
    end
  end

  context "duplicate courses" do
    before do
      Course.create!(:department => "CS", :number => 123, :title => "okay", :credits => 4)      
    end

    it "should be invalid to add duplicate course in department and number" do
      Course.new(
              :department => 'CS', :number => 123, :title => 'Duplicate!', :credits => 3
      ).should_not be_valid
    end

    it "should be okay if number is reused in another department" do
      Course.new(
              :department => 'IS', :number => '108',
              :title => 'IS in the Middle Ages', :credits => 3
      ).should be_valid
    end
  end

  it "should have an identifier" do
    Course.new(
              :department => 'XY', :number => 887, :title => 'Duplicate!', :credits => 3
      ).identifier.should == "XY 887"
  end

end
