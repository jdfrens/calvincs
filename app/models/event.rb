# == Schema Information
# Schema version: 20100315182611
#
# Table name: events
#
#  id          :integer         not null, primary key
#  type        :string(255)
#  title       :string(255)
#  subtitle    :string(255)
#  description :text
#  start       :datetime
#  stop        :datetime
#  descriptor  :string(255)
#  presenter   :string(255)
#  updated_at  :datetime
#  created_at  :datetime
#  location    :string(255)
#

class Event < ActiveRecord::Base

  validates_presence_of :title, :descriptor, :description, :start, :stop

  before_validation :use_length_for_stop_time
  before_validation :use_type_for_descriptor

  scope :upcoming, lambda { where('stop > ?', Time.now).order("start") }

  scope :find_within,
              lambda { |range_start, range_stop|
                where("(? < start AND start < ?) OR (? < stop AND stop < ?) OR (start < ? AND ? < stop)",
                      range_start, range_stop,
                      range_start, range_stop,
                      range_start, range_start) }

  def self.by_year(year)
    find_within(Time.local(year, 1, 1, 0, 0), Time.local(year, 12, 31, 23, 59))
  end

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
    find_within(
      Time.local(today.year, today.month, today.day, 0, 0),
      Time.local(today.year, today.month, today.day, 23, 59))
  end

  def self.within_week
    find_within(Chronic.parse("midnight"), Chronic.parse("6 days from now at midnight"))
  end

  def self.default_start_and_stop
    start = Chronic.parse("1 day from now at 3:30p")
    stop = start + 1.hour
    [start, stop]
  end

  def full_title
    if subtitle.blank?
      title
    else
      title + ": " + subtitle
    end
  end

  def elapsed
    stop - start
  end

  def length
  end

  def length=(t)
  end

  def length=(t)
    case event_kind
    when "Colloquium"
      @length = t.to_i.hours
    when "Conference"
      @length = t.to_i.days
    end
  end

  def length
    case event_kind
    when "Colloquium"
      elapsed / 1.hour
    when "Conference"
      (elapsed / 1.day).ceil
    end
  end

  SCALES = { "Colloquium" => "hours", "Conference" => "days" }
  def scale
    SCALES[event_kind]
  end

  def timing
    case event_kind
    when "Colloquium"
      start.to_s(:colloquium)
    when "Conference"
      "#{start.to_s(:conference)} thru #{stop.to_s(:conference)}"
    end
  end

  protected

  def use_length_for_stop_time
    if @length
      self.stop = self.start + @length
    end
  end

  def use_type_for_descriptor
    if not self.descriptor
      self.descriptor = self[:event_kind].downcase
    end
  end
end
