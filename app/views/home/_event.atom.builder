feed.entry(event,
           :published => Date.today,
           :id => "tag:#{request.host},#{@schema_date}:#{kind}/#{event.id}") do |entry|
  entry.title event.full_title
  entry.content event.description
  entry.author do |author|
    author.name "Computing@Calvin"
  end
end
