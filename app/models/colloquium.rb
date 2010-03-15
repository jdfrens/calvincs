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

class Colloquium < Event

  def length
    elapsed / 1.hour
  end

  def length=(t)
    @length = t.to_i.hours
  end

  def scale
    "hours"
  end

  def timing
    start.to_s(:colloquium)
  end

end
