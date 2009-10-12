# == Schema Information
# Schema version: 20091012011757
#
# Table name: newsitems
#
#  id           :integer         not null, primary key
#  headline     :string(255)
#  content      :text
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  expires_at   :datetime
#  teaser       :string(255)
#  goes_live_at :datetime
#

class Newsitem < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :headline
  validates_presence_of :teaser
  validates_presence_of :content
  validates_presence_of :user, :message => 'is invalid'
  validates_associated  :user, :allow_nil => false
  validates_presence_of :goes_live_at
  validates_presence_of :expires_at

  def self.find_current
    self.scoped(:conditions => ['goes_live_at <= ? AND expires_at >= ?', Time.now, Time.now],
            :order => 'goes_live_at DESC')
  end

  def self.find_by_year(year, max = :today)
    lower_bound = Time.local(year, 1, 1)
    upper_bound = Time.local(year, 12, 31)
    if max == :today
      upper_bound = [upper_bound, Time.now].min
    end
    self.scoped(:conditions => { :goes_live_at => lower_bound..upper_bound },
            :order => 'goes_live_at DESC'
    )
  end

  def self.find_news_years
    if self.minimum(:goes_live_at)
      self.minimum(:goes_live_at).year..self.maximum(:goes_live_at).year
    else
      2000..1999
    end
  end

  def last_updated_dates
    [updated_at]
  end

  def goes_live_at_formatted
    goes_live_at.strftime '%m/%d/%Y'
  end

  def goes_live_at_formatted=(value)
    self.goes_live_at = Time.parse(value)
  end

  def expires_at_formatted
    expires_at.strftime '%m/%d/%Y'
  end

  def expires_at_formatted=(value)
    self.expires_at = Time.parse(value)
  end

  def is_current?
    (goes_live_at <= Time.now) && (expires_at >= Time.now)
  end

end
