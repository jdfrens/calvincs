module EventsHelper
  
  def format_titles(event)
    titles = "<span class=title>" + johnny_textilize(event.title, :no_paragraphs) + "</span>"
    unless event.subtitle.blank?
      titles += ": <br /><span class=subtitle>" + johnny_textilize(event.subtitle, :no_paragraphs) + "</span>"
    end
    titles
  end
  
end
