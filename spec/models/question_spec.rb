require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Question do

  fixtures :faqs, :questions

  it "should validate" do
    question = Question.new
    question.should be_invalid
    question.errors.on(:query).should == "can't be blank"
    question.errors.on(:answer).should == "can't be blank"
    question.errors.on(:faq_id).should == "can't be blank"  
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
