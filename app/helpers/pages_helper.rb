module PagesHelper
  def page_title(page)
    page.subpage? ? "SUBPAGE identified as #{page.identifier}" : h(page.title)
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
end
