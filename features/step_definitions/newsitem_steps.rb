Given /^the following news items$/ do |table|
  defaults = { "goes_live_at" => 2.days.ago.to_s(:db),
               "expires_at" => 1.day.from_now.to_s(:db),
               :user => User.find_by_username("jeremy")}
  table.hashes.each do |hash|
    Newsitem.create!(parse_news_item_dates(defaults.merge(hash)))
  end
  Newsitem.count.should == table.hashes.size
end

module NewsItemHelpers
  def parse_news_item_dates(hash)
    hash.
            merge({ "goes_live_at" => parse_date(hash["goes_live_at"]) }).
            merge({ "expires_at" => parse_date(hash["expires_at"]) })
  end
end
World(NewsItemHelpers)

module DateHelpers
  def parse_date(string)
    case string
      when "yesterday"
        24.hours.ago.to_s(:db)
      when "today"
        1.minute.from_now.to_s(:db)
      when "tomorrow"
        24.hours.from_now.to_s(:db)
      else
        string
    end
  end
end
World(DateHelpers)
