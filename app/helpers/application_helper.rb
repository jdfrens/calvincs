# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def course_links(string)
    Course.all.each do |course|
      string = string.gsub(/\b#{course.short_identifier}\b/, "\"#{course.identifier} (#{course.full_title})\":#{course_path(course)}")
    end
    string
  end

  def johnny_textilize(string, paragraphs = :yes)
    string = course_links(string)
    if paragraphs == :no_paragraphs
      RedCloth.new(string, [:lite_mode]).to_html
    else
      RedCloth.new(string).to_html
    end
  end

  def link_to_current_newsitem(newsitem, options = {})
    options = { :text => h(newsitem.headline) }.merge(options)
    link_to options[:text],
            hash_for_newsitems_path.merge(:anchor => "news-item-#{newsitem.id}"),
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

  # helper functions from Railscasts
  # http://railscasts.com/episodes/197-nested-model-form-part-2
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :form => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
end
