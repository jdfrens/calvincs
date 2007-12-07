module EventHelper
  
  def format_titles(event)
    titles = "<span class=title>" + textilize_without_paragraph(event.title) + "</span>"
    if event.subtitle
      titles += ": <br /><span class=subtitle>" + textilize_without_paragraph(event.subtitle) + "</span>"
    end
    titles
  end
  
end
