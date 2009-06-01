Given /^I am logged in as an editor$/ do
  visit "/users/login"
  fill_in("user[username]", :with => "jeremy")
  fill_in("user[password]", :with => "jeremypassword")
  click_button "Login"
end

Given /^I am not logged in$/ do
  visit "/users/logout"
end
