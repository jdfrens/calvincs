Then /^I should see some error$/ do
  response.should have_selector(".error")
end

Then /^I should see "([^\"]*)" and not "([^\"]*)"$/ do |seen_text, unseen_text|
  Then "I should see \"#{seen_text}\""
  Then "I should not see \"#{unseen_text}\""
end
