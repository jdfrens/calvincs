require File.dirname(__FILE__) + '/../test_helper'

class QuestionTest < Test::Unit::TestCase
  fixtures :questions

  def test_validations
    assert_invalid Question.new, [:query, :answer, :faq_id]
  end
end
