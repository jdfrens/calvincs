Given /^the following colloquia/ do |table|
  table.hashes.each do |hash|
    create_colloquium(hash)
  end
end

Given /^the following conferences/ do |table|
  table.hashes.each do |hash|
    create_conference(hash)
  end
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

module EventHelpers
  def create_colloquium(hash)
    hash = { "start" => 24.hours.from_now.to_s(:db),
                 "stop" =>  25.hours.from_now.to_s(:db),
                 "descriptor" => "colloquium" }.merge(hash)
    case hash["when"]
      when "yesterday"
        hash = hash.merge("start" => 24.hours.ago.to_s(:db), "stop" => 23.hours.ago.to_s(:db))
    end
    Colloquium.create!(:title => hash["title"],
                       :start => hash["start"], :stop => hash["stop"],
                       :descriptor => hash["descriptor"])
  end

  def create_conference(hash)
    hash = { "start" => 2.days.from_now.to_s(:db),
             "stop" => 5.days.from_now.to_s(:db),
             "descriptor" => "conference" }.merge(hash)
    case hash["when"]
      when "yesterday"
        hash = hash.merge("start" => 5.days.ago.to_s(:db), "stop" => 1.day.ago.to_s(:db))
    end
    Conference.create!(:title => hash["title"],
                       :start => hash["start"], :stop => hash["stop"],
                       :descriptor => hash["descriptor"])
  end
end
World(EventHelpers)
