require File.dirname(__FILE__) + '/../test_helper'

class FaqTest < Test::Unit::TestCase
  fixtures :faqs

  def test_validations
    assert_invalid Faq.new, [:title, :identifier]
    assert_invalid Faq.new(:title => 'f', :identifier => '123'), [:identifier]
    assert_invalid Faq.new(:title => 'f', :identifier => 'foo bar'), [:identifier]
  end
end
