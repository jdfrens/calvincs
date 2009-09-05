feed.entry(todays_event,
           :published => Date.today,
           :id => "tag:#{request.host},#{@schema_date}:TodaysEvent/#{todays_event.id}") do |entry|
  entry.title todays_event.full_title
  entry.content todays_event.description
  entry.author do |author|
    author.name "Computing@Calvin"
  end
end
