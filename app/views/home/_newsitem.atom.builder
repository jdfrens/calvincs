feed.entry(newsitem, :published => newsitem.goes_live_at) do |entry|
  entry.title newsitem.headline
  entry.content newsitem.content
  entry.author do |author|
    author.name "Computing@Calvin"
  end
end
