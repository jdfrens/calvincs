feed.entry(event,
           :published => Date.today,
           :id => "tag:#{request.host},#{@schema_date}:#{kind}/#{event.id}") do |entry|
  entry.title johnny_textilize_lite(event.full_title), :type => "html"
  entry.content johnny_textilize(event.description), :type => "html"
  entry.author do |author|
    author.name "Computing@Calvin"
  end
end
