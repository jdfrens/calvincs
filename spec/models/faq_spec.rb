# == Schema Information
# Schema version: 20091012011757
#
# Table name: faqs
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  identifier :string(255)
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Faq do

  fixtures :faqs, :questions

  context "validations" do
    it "should be valid with title and identifier" do
      Faq.new(:title => 'f', :identifier => "foobar").should be_valid
    end

    it "should be invalid without title and identifier" do
      Faq.new.should be_invalid
    end

    it "should require valid identifier" do
      faq = Faq.new(:title => 'f', :identifier => '123')
      faq.should be_invalid
      faq.errors.on(:identifier).should == "is invalid"

      faq = Faq.new(:title => 'f', :identifier => 'foo bar')
      faq.should be_invalid
      faq.errors.on(:identifier).should == "is invalid"
    end
  end

  def test_has_many_questions
    assert_equal [], faqs(:empty_faq).questions
    assert_equal [questions(:student1), questions(:student2)],
                 faqs(:student_faq).questions
  end

  def test_delete_all_questions
    faqs(:student_faq).destroy
    assert_equal 0, Question.count
  end

  def test_last_modified
    assert_equal faqs(:student_faq).updated_at, faqs(:student_faq).last_modified
    question = questions(:student1)
    question.query = 'Modified query'
    question.save!
    question.reload
    assert_equal question.updated_at, faqs(:student_faq).last_modified
  end

end
