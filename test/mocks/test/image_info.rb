class ImageInfo
  
  def self.fake_size(url, size)
    @@sizes ||= {}
    @@sizes[url] = size
  end

  def initialize(url)
    @@seen_urls ||= []
    @@seen_urls << url
    @url = url
  end
  
  def width
    if @@sizes[@url]
      @@sizes[@url][:width]
    else
      raise "#{@url} was unexpected"
    end
  end
  
  def height
    if @@sizes[@url]
      @@sizes[@url][:height]
    else
      raise "#{@url} was unexpected"
    end
  end
  
end