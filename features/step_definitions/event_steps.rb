Given /^the following colloquia/ do |table|
  defaults = {:start => 2.days.ago.to_s(:db), :stop => (2.days.ago + 1.hour).to_s(:db), :descriptor => "colloquium"}
  table.hashes.each do |hash|
    Colloquium.create!(defaults.merge(hash))
  end
end

Given /^the following conferences/ do |table|
  defaults = {:start => 2.days.ago.to_s(:db), :stop => (2.days.ago + 1.hour).to_s(:db), :descriptor => "conference"}
  table.hashes.each do |hash|
    Conference.create!(defaults.merge(hash))
  end
end

When /^I view the list of events$/ do
  visit '/event'
end

When /^I select tomorrow at "([^\"]*)" as the date and time$/ do |time|
  select_datetime((Date.today + 1).to_s + " " + time)
end

When /^I select tomorrow as the date$/ do
  select_date((Date.today + 1).to_s)
end

Then /^I should see tomorrow and two days later$/ do
  response.should contain(1.day.from_now.to_s(:conference))
  response.should contain(3.days.from_now.to_s(:conference))
end
