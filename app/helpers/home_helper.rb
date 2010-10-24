module HomeHelper
  def event_content_for_atom(event)
    content_tag(:h1, format_titles(event)) +
      event_details(event) +
      johnny_textilize(event.description)
  end
end
