Then /^I should see some error$/ do
  page.should have_xpath("//*[@class='flash error']")
end

Then /^I should see "([^\"]*)" and not "([^\"]*)"$/ do |seen_text, unseen_text|
  Then "I should see \"#{seen_text}\""
  Then "I should not see \"#{unseen_text}\""
end

Then /^I should see "([^"]*)" button/ do |name|
  find_button(name).should_not be_nil
end

Then /^I should not see "([^"]*)" button$/ do |name|
  begin
    find_button(name)
    fail("found \"#{name}\" button")
  rescue Capybara::ElementNotFound
    # good!
  end
end
