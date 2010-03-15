Then /^I should see a link to "([^\"]*)"$/ do |url|
  response.should have_selector("a", :href => url)
end
