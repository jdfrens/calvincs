module EventsHelper

  def format_titles(event)
    titles = content_tag(:span, johnny_textilize_lite(event.title), :class => "title").html_safe
    unless event.subtitle.blank?
      titles += ": <br />".html_safe + content_tag(:span, johnny_textilize_lite(event.subtitle), :class => "subtitle").html_safe
    end
    titles.html_safe
  end

  def event_details(event)
    content_tag(:p, :class => "more") do
      span_or_empty(event, :presenter) +
        span_or_empty(event, :location) +
        content_tag(:span, event.timing, :class => "when")
    end
  end

  def span_or_empty(event, attribute)
    if event.presenter.blank?
      ""
    else
      content_tag(:span, event.send(attribute), :class => attribute) + tag(:br)
    end
  end

end
