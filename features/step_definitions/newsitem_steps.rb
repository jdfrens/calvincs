Given /^the following news items$/ do |table|
  defaults = { "goes_live_at" => "two days ago",
               "expires_at" => "tomorrow",
               :user => User.find_by_username("jeremy")}
  table.hashes.each do |hash|
    Newsitem.create!(parse_newsitem_dates(defaults.merge(hash)))
  end
  Newsitem.count.should == table.hashes.size
end

module NewsItemHelpers
  def parse_newsitem_dates(hash)
    hash.merge({
      "goes_live_at" => Chronic.parse(hash["goes_live_at"]),
      "expires_at" => Chronic.parse(hash["expires_at"])
      })
  end
end
World(NewsItemHelpers)
