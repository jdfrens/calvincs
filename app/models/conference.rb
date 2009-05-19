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