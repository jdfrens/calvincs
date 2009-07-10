Then /^I should see "([^\"]*)" as (.*)$/ do |text, selector|
  response.should have_selector(selector, :content => text)
end