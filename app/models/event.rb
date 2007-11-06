class Event < ActiveRecord::Base
  
  def self.find_within(range_start, range_stop)
    self.find(:all,
      :conditions => ["(? < start AND start < ?) OR (? < stop AND stop < ?) OR (start < ? AND ? < stop)",
                      range_start, range_stop,
                      range_start, range_stop,
                      range_start, range_start])
  end
end

class Colloquium < Event

end

class Conference < Event

end