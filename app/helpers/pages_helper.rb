module PagesHelper
  def page_title(page)
    page.subpage? ? "SUBPAGE identified as #{page.identifier}" : h(page.title)
  end

  def in_place_editor(field)
    tag("span", :class => "edit", :id => "page_#{field}") +
      @page.send(field) +
    "</span>" +
    javascript_tag do
      render "shared/in_place_editor.js", :url => page_path(@page), :field => field
    end
  end
end
