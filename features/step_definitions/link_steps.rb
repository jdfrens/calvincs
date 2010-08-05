Then /^I should see a link to "([^\"]*)"$/ do |url|
  page.should have_xpath("//a", :href => url)
end
