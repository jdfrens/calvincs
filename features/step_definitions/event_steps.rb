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
