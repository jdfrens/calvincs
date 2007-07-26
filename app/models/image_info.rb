require "image_size"
require "open-uri"
  
class ImageInfo

  def initialize(url)
    open(url, "rb") do |file_handle|
      @size = ImageSize.new(file_handle.read).get_size
    end
  end
  
  def width
    @size[0]
  end
  
  def height
    @size[1]
  end
  
end