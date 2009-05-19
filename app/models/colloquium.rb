class Colloquium < Event

  def length
    elapsed / 1.hour
  end

  def length=(t)
    @length = t.to_i.hours
  end

  def timing
    start.to_s(:colloquium)
  end

end
