require File.dirname(__FILE__) + '/../test_helper'

class FaqTest < Test::Unit::TestCase
  fixtures :faqs, :questions

  def test_validations
    assert_invalid Faq.new, [:title, :identifier]
    assert_invalid Faq.new(:title => 'f', :identifier => '123'), [:identifier]
    assert_invalid Faq.new(:title => 'f', :identifier => 'foo bar'), [:identifier]
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

end
