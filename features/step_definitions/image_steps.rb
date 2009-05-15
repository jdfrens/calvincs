Given /^the following images$/ do |table|
  table.hashes.each do |hash|
    Image.create!(hash)
  end
end

Then /^I should see an image "([^\"]*)"$/ do |arg1|
  pending
end
