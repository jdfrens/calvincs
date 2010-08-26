class MenuRenderer
  def initialize(template, *menu_items)
    @template = template
    @menu_items = menu_items
  end
  
  def render_menu(menu_items = nil)
    menu_items ||= @menu_items
    @template.content_tag(:ul, menu_items.map { |item| render_item(item) }.join(" ").html_safe)    
  end
  
  def render_item(menu_item)
    @template.content_tag(:li, (content(menu_item) + submenu(menu_item)).html_safe, :class => css_class(menu_item))
  end
  
  def content(menu_item)
    if @template.controller.request.fullpath == menu_item.path
      menu_item.text
    else
      @template.link_to(menu_item.text, menu_item.path, :title => menu_item.popup)
    end
  end

  def submenu(menu_item)
    if menu_item.active?(@template) && menu_item.has_submenu?
      render_menu(menu_item.submenu_items)
    else
      ""
    end
  end
  
  def css_class(menu_item)
    if !menu_item.submenu_item? && menu_item.active?(@template)
      "current"
    else
      nil
    end
  end
end
