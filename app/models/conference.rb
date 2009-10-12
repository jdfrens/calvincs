# == Schema Information
# Schema version: 20090905181738
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

end
