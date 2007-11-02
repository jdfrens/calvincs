require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events

  # Event#this_week
  # Event#next_week
  # Event#this_month
  # Event#this_semester
  # Event#this_year (school year!)
  
  def test_inheritance
    assert_equal Colloquium, events(:old_colloquium).class
  end
end
