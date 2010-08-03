module EventsHelper
  
  def format_titles(event)
    titles = "<span class=title>" + johnny_textilize_lite(event.title) + "</span>"
    unless event.subtitle.blank?
      titles += ": <br /><span class=subtitle>" + johnny_textilize_lite(event.subtitle) + "</span>"
    end
    titles.html_safe
  end
  
end
