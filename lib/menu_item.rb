class MenuItem
  attr_reader :text
  attr_reader :path
  attr_reader :popup
  
  def initialize(text, path, options={})
    @text = text
    @path = path
    @popup = options[:popup] || text
    @active_proc = options[:active] || lambda { |p| false }
    yield self if block_given?
  end
  
  def active?(params, request)
    @active_proc.call(params) || (@path == request.fullpath)
  end
end