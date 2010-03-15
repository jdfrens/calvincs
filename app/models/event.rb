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

  named_scope :upcoming, lambda { || { :conditions => ['stop > ?', Time.now] } }

  named_scope :find_within,
              lambda { |range_start, range_stop|
                { :conditions => ["(? < start AND start < ?) OR (? < stop AND stop < ?) OR (start < ? AND ? < stop)",
                                  range_start, range_stop,
                                  range_start, range_stop,
                                  range_start, range_start] } }

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
    find_within(Time.local(today.year, today.month, today.day, 0, 0), Time.local(today.year, today.month, today.day, 23, 59))
  end

  def self.within_week
    find_within(Chronic.parse("midnight"), Chronic.parse("6 days from now at midnight"))
  end

  def self.new_event(params)
    case params[:kind].downcase
      when "colloquium"
        Colloquium.new(params)
      when "conference"
        Conference.new(params)
      else
        raise "Invalid event type #{params[:kind]}"
    end
  end

  def full_title
    if subtitle.blank?
      title
    else
      title + ": " + subtitle
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
