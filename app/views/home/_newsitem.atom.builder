feed.entry(newsitem, :published => newsitem.goes_live_at) do |entry|
  entry.title newsitem.headline
  entry.content textilize(newsitem.content), :type => "html"
  entry.author do |author|
    author.name "Computing@Calvin"
  end
end
