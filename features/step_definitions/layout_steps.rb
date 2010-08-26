When /^I follow menu item "([^"]*)"$/ do |item|
  When "I follow \"#{item}\" within \"#navbar\""
end

Then /^I should see plain menu item "([^"]*)"$/ do |item|
  Then "I should see \"#{item}\" within \"#navbar\""
end

Then /^I should see linked menu item "([^"]*)"$/ do |item|
  Then "I should see \"#{item}\" within \"#navbar a\""
end

Then /^I should not see menu item "([^"]*)"$/ do |item|
  Then "I should not see \"#{item}\" within \"#navbar\""
end
