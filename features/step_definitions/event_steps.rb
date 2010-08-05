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

When /^I select tomorrow as the date$/ do
  select_date(Chronic.parse("tomorrow"), :from => "conference_start")
end

Then /^I should see tomorrow as event date$/ do
  page.should have_xpath("//span[@class='time']",
    :text => Chronic.parse("tomorrow").to_s(:conference))
end

Then /^I should see tomorrow and two days later$/ do
  page.should have_content(Chronic.parse("tomorrow").to_s(:conference).gsub(/\s+/, " "))
  page.should have_content(Chronic.parse("three days from now").to_s(:conference).gsub(/\s+/, " "))
end

module EventHelpers
  def create_colloquium(hash)
    raise "don't specify when, use Chronic!" if hash["when"]
    hash = { "start" => "tomorrow at 3:30pm",
             "descriptor" => "colloquium",
             "description" => "very boring description" }.merge(hash)
    hash["start"] = Chronic.parse(hash["start"])
    unless hash["length"]
      hash["stop"] = Chronic.parse(hash["stop"]) || (hash["start"] + 1.hour)
    end
    Colloquium.create!(hash)
  end

  def create_conference(hash)
    hash = { "descriptor" => "conference" }.merge(hash)
    hash["start"] = Chronic.parse(hash["start"]) || 2.days.from_now
    unless hash["length"]
      hash["stop"] = Chronic.parse(hash["stop"]) || hash["start"]
    end
    Conference.create!(hash)
  end
end

World(EventHelpers)
