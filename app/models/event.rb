class Event < ActiveRecord::Base
  def within(range)
    range.include?(start) || range.include?(stop)
  end
end

class Colloquium < Event
  def stop
    start + length.hours
  end
end

class Conference < Event
  def stop
    start + length.days
  end
end