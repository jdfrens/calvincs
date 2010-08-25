class MenuItem
  attr_reader :text
  attr_reader :path
  attr_reader :popup
  attr_reader :submenu_items
  
  def initialize(text, path, options={})
    @text = text
    @path = path
    @popup = options[:popup] || text
    @active_proc = options[:active] || lambda { |p| false }
    @submenu_items = options[:submenu_items] || []
    yield self if block_given?
  end
  
  def active?(template)
    @active_proc.call(template.params) || 
      (@path == template.controller.request.fullpath) || 
      submenu_items.any? { |item | item.active?(template) }
  end
  
  def has_submenu?
    not submenu_items.empty?
  end
end