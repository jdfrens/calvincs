schema_date = "2005"

atom_feed(:schema_date => schema_date) do |feed|
  feed.title("Calvin College Computer Science - News and Events")
  feed.updated(@updated_at)

  @todays_events.each do |event|
    feed.entry(event,
               :published => Date.today,
               :id => "tag:#{request.host},#{schema_date}:TodaysEvent/#{event.id}") do |entry|
      entry.title event.full_title
      entry.content event.description
      entry.author do |author|
        author.name "Computing@Calvin"
      end
    end
  end

  @newsitems.each do |newsitem|
    feed.entry(newsitem, :published => newsitem.goes_live_at) do |entry|
      entry.title newsitem.headline
      entry.content newsitem.content
      entry.author do |author|
        author.name "Computing@Calvin"
      end
    end
  end
end
