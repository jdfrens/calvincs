class Event < ActiveRecord::Base

  validates_presence_of :title, :descriptor, :start, :stop

  before_validation :use_length_for_stop_time
  before_validation :use_type_for_descriptor

  named_scope :upcoming, :conditions => ['stop > ?', Time.now]

  named_scope :find_within,
              lambda { |range_start, range_stop|
                { :conditions => ["(? < start AND start < ?) OR (? < stop AND stop < ?) OR (start < ? AND ? < stop)",
                                  range_start, range_stop,
                                  range_start, range_stop,
                                  range_start, range_start] } }

  def self.years_of_events
    first_year..last_year
  end

  def self.first_year
    Event.minimum(:start).year
  end

  def self.last_year
    Event.maximum(:stop).year
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

  def self.new_event(params)
    case params[:kind].downcase
      when "colloquium"
        Colloquium.new(params)
      when "conference":
        Conference.new(params)
      else
        raise "Invalid event type #{params[:kind]}"
    end
  end

  def kind
    self[:type]
  end

  def kind=(type)
    self[:type] = type
  end

  def elapsed
    stop - start
  end

  def length
    nil
  end

  protected

  def use_length_for_stop_time
    if @length
      self.stop = self.start + @length
    end
  end

  def use_type_for_descriptor
    if not self.descriptor
      self.descriptor = self[:type].downcase
    end
  end
end
