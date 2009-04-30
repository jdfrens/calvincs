require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class FaqTest < ActiveRecord::TestCase
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
  
  def test_last_modified
    assert_equal faqs(:student_faq).updated_at, faqs(:student_faq).last_modified
    question = questions(:student1)
    question.query = 'Modified query'
    question.save!
    question.reload
    assert_equal question.updated_at, faqs(:student_faq).last_modified
  end

end
