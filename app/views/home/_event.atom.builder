feed.entry(event,
           :published => Date.today,
           :id => "tag:#{request.host},#{@schema_date}:#{kind}/#{event.id}") do |entry|
  entry.title textilize_without_paragraph(event.full_title)
  entry.content textilize(event.description), :type => "html"
  entry.author do |author|
    author.name "Computing@Calvin"
  end
end
