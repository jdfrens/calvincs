require File.dirname(__FILE__) + '/../test_helper'

class QuestionTest < Test::Unit::TestCase
  fixtures :faqs, :questions

  def test_validations
    assert_invalid Question.new, [:query, :answer, :faq_id]
  end
  
  def test_belongs_to_faq
    assert_equal faqs(:student_faq), questions(:student1).faq
    assert_equal faqs(:student_faq), questions(:student2).faq
  end
end
