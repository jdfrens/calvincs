require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class QuestionTest < Test::Unit::TestCase
  fixtures :faqs, :questions

  def test_validations
    assert_invalid Question.new, [:query, :answer, :faq_id]
  end
  
  def test_belongs_to_faq
    assert_equal faqs(:student_faq), questions(:student1).faq
    assert_equal faqs(:student_faq), questions(:student2).faq
  end

  def test_acts_as_list_for_faq
    faq = faqs(:student_faq)
    question1 = questions(:student1)
    question2 = questions(:student2)
    assert_equal [question1, question2], faq.questions
    
    faq.questions[0].move_lower
    faq.reload
    question1.reload
    question2.reload
    
    assert_equal [question2, question1], faq.questions(true)
  end

end
