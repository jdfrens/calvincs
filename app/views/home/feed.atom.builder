atom_feed do |feed|
  feed.title("Calvin College Computer Science - News and Events")

  @newsitems.each do |newsitem|
    feed.entry(newsitem, :published => newsitem.goes_live_at) do |entry|
      entry.title newsitem.headline
      entry.content newsitem.content
    end
  end
end
