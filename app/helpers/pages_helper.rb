module PagesHelper
  def page_title(page)
    page.subpage? ? "SUBPAGE identified as #{page.identifier}" : page.title
  end

  def in_place_editor(field)
    content_tag(:span, :class => "edit", :id => "page_#{field}") do
      @page.send(field)
    end +
            javascript_tag do
              render "shared/in_place_editor.js", :url => page_path(@page), :field => field
            end
  end

  def content_editor
    javascript_tag do
      render "content_editor.js"
    end
  end

  def show_page_link(page)
    case page.identifier
    when /^_home/
      link_to "show home page", "/"
    when /^_([^_]+)_/
      person = User.find_by_username($1)
      [ link_to("show faculty page", people_path),
        link_to("show #{$1} page", people_path(person))].join(", ").html_safe
    else
      link_to "show this page", page_path(page)
    end
  end
end
