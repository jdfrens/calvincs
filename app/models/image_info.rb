require "image_size"
require "open-uri"

class ImageInfo

  @@hardcode = {}

  def self.hardcode(url, width, height)
    @@hardcode[url] = [width, height]
  end

  def initialize(url)
    if @@hardcode[url]
      @size = @@hardcode[url]
    else
      open(url, "rb") do |file_handle|
        @size = ImageSize.new(file_handle.read).get_size
      end
    end
  end

  def width
    @size[0]
  end

  def height
    @size[1]
  end

end
