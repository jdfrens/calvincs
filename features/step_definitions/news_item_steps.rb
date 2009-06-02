Given /^the following news items$/ do |table|
  defaults = { "goes_live_at" => 2.days.ago.to_s(:db),
          "expires_at" => 1.day.from_now.to_s(:db),
          :user => User.find_by_username("jeremy")}
  table.hashes.each do |hash|
    NewsItem.create!(defaults.merge(hash))
  end
end
