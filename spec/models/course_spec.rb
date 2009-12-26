# == Schema Information
# Schema version: 20091012011757
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

  context "presence of validations" do
    before(:each) do
      @course = Course.new
    end

    it "should be invalid" do
      @course.should be_invalid
    end

    it "should validate department" do
      @course.should validate_presence_of(:department)
    end

    it "should validate number" do
      @course.should validate_presence_of(:number)
    end

    it "should validate title" do
      @course.should validate_presence_of(:title)
    end

    it "should validate credits" do
      @course.should validate_presence_of(:credits)
    end
  end

  context "number validations" do
    it "should complain about bad values" do
      course = Course.new(
              :department => 'CS', :number => 'bad', :title => 'okay', :credits => 4
      )
      course.should be_invalid
      course.should have(1).error_on(:number)
    end
  end

  context "credit validations" do
    it "should complain about bad values" do
      course = Course.new(
              :department => 'CS', :number => 555, :title => 'okay', :credits => 'iv'
      )
      course.should be_invalid
      course.should have(1).error_on(:credits)
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
    Factory.build(:course, :department => 'XY', :number => 887).identifier.should == "XY 887"
  end

  it "should build a full title" do
    Factory.build(:course, :department => 'AB', :number => 452, :title => "THE Title").
            full_title.should == "AB 452: THE Title"
  end
end
