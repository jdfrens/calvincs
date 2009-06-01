Given /^the following news items$/ do |table|
  table.hashes.each do |hash|
    NewsItem.create!(hash.merge :user => User.find_by_username("jeremy"))
  end
end
