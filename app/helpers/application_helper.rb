# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper  
  def link_to_current_news_item(news_item, options = {})
    options = { :text => h(news_item.headline) }.merge(options)
    link_to options[:text],
          { :controller => "news_items", :anchor => "news-item-#{news_item.id}" },
          { :class => options[:class] }
  end
  
  def title
    "<title>" +
    ["Calvin College Computer Science", @title].compact.join(" - ") +
    "</title>"
  end

  def spinner_id(suffix = nil)
    suffix ? "spinner_#{suffix}" : "spinner"    
  end
  
  def spinner(options = {})
    id_suffix = options[:number] || options[:suffix]
    image_tag 'spinner_moz.gif', :id => spinner_id(id_suffix), :style => "display:none;"
  end

  def image_class(image)
    "img-right-#{image.usability}"
  end
  
  def menu_item(text, url, options = {})
    options = { :title => text }.merge(options)
    if current_page?(url)
      options[:class] = "current"
    end
    content_tag(:li, link_to_unless_current(text, url, { :title => options[:title] }), :class => options[:class])
  end
end
