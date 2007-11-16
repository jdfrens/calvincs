class Event < ActiveRecord::Base
  
  validates_presence_of :title, :descriptor, :start, :stop

  def self.find_within(range_start, range_stop)
    self.find(:all,
      :conditions => ["(? < start AND start < ?) OR (? < stop AND stop < ?) OR (start < ? AND ? < stop)",
                      range_start, range_stop,
                      range_start, range_stop,
                      range_start, range_start])
  end
  
  def self.find_by_today(today=Time.now)
    find_within(Time.local(today.year, today.month, today.day, 0, 0), Time.local(today.year, today.month, today.day, 23, 59))
  end
  
  def self.find_by_week_of(date=Time.now, options = {})
    options[:sunday] = true if options[:sunday].nil?
    if options[:sunday]
      start = date - date.wday.days
    else
      start = date
    end
    stop = date + 6.days - date.wday.days
    find_within(start, stop)
  end
  
  def self.find_by_semester_of(date=Time.now)
    if date.month < 8
      start = Time.local(date.year, 1,  1)
      stop = Time.local(date.year,  7, 31)
    else
      start = Time.local(date.year, 8,  1)
      stop = Time.local(date.year, 12, 31)
    end
    find_within(start, stop)
  end
end

class Colloquium < Event

end

class Conference < Event

end