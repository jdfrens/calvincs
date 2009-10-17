# == Schema Information
# Schema version: 20091012011757
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

class Conference < Event

  def length
    elapsed / 1.day
  end

  def length=(t)
    @length = t.to_i.days
  end

  def timing
    "#{start.to_s(:conference)} thru #{stop.to_s(:conference)}"
  end

  def scale
    "days"
  end

end
