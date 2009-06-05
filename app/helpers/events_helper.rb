module EventsHelper
  
  def format_titles(event)
    titles = "<span class=title>" + textilize_without_paragraph(event.title) + "</span>"
    unless event.subtitle.blank?
      titles += ": <br /><span class=subtitle>" + textilize_without_paragraph(event.subtitle) + "</span>"
    end
    titles
  end
  
end
