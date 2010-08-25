require 'menu_item'

module ApplicationHelper
  def render2(*args)
    render(*args)
  end
  
  def textilized_link(course)
    if course.url.blank?
      course.identifier
    else
      "\"#{course.identifier}(#{course.full_title})\":#{course.url}"
    end
  end

  def course_links(string)
    Course.all.each do |course|
      string = string.gsub(/\b#{course.short_identifier}\b/, textilized_link(course))
    end
    string
  end

  def johnny_textilize(string)
    textilized = RedCloth.new(course_links(string || ""))
    textilized.hard_breaks = false
    textilized.to_html.html_safe
  end

  def johnny_textilize_lite(string)
    textilized = RedCloth.new(course_links(string || ""), [:lite_mode])
    textilized.hard_breaks = false
    textilized.to_html.html_safe
  end

  def link_to_current_newsitem(newsitem, options = {})
    options = { :text => h(newsitem.headline) }.merge(options)
    link_to options[:text],
            hash_for_newsitems_path.merge(:anchor => "news-item-#{newsitem.id}"),
            { :class => options[:class] }
  end

  def title
    "<title>" +
            ["Calvin College", "Computer Science", @title].compact.join(" - ") +
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

  def menu_item(text, url, options = {}, &block)
    menu_item = ::MenuItem.new(text, url, options)
    options[:current] = options[:current] || menu_item.active?(params, controller.request)
    if options[:current]
      options[:class] = "current"
    end
    content = options[:current] ? menu_item.text : link_to_unless_current(menu_item.text, url, :title => menu_item.popup)
    if options[:current] && block_given?
      content = content + with_output_buffer(&block)
    end
    content_tag(:li, content.html_safe, :class => options[:class])
  end
  
  def events_submenu?(params)
    params[:controller] == "events"
  end
  
  def newsitems_submenu?(params)
    params[:controller] == "newsitems"
  end
  
  def colloquium_path(event)
    event_path(event)
  end
  
  def colloquium_url(event)
    event_url(event)
  end
  
  def colloquia_path
    events_path
  end
  
  def conference_path(event)
    event_path(event)
  end

  def conference_url(event)
    event_url(event)
  end

  def conferences_path
    events_path
  end

  # helper functions from Railscasts
  # http://railscasts.com/episodes/197-nested-model-form-part-2
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :form => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
end
