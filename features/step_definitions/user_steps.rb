Given /^I am logged in as an editor$/ do
  visit "/users/login"
  fill_in("user[username]", :with => "jeremy")
  fill_in("user[password]", :with => "jeremypassword")
  click_button "Login"
end

Given /^I am not logged in$/ do
  visit "/users/logout"
end

Given /^the following users$/ do |table|
  faculty = Role.find_by_name("faculty")
  table.hashes.each do |hash|
    role_name = hash[:role]
    if role_name
      hash[:role] = Role.find_by_name(role_name)
      raise "#{role_name} not a valid role" if role_name.nil?
    else
      hash[:role] = faculty
    end
    User.create!(hash.merge( :email_address => "#{hash[:username]}@example.edu",
                             :password => "password", :password_confirmation => "password", :role => hash[:role]))
  end
end

When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  When "I go to the login page"
  Then 'I should see "Please login"'
  When "I fill in \"user[username]\" with \"#{username}\""
  When "I fill in \"user[password]\" with \"#{password}\""
  When "I press \"Login\""
end

Then /^user "([^\"]*)" should have password "([^\"]*)"$/ do |username, password|
  user = User.find_by_username(username)
  user.password_hash.should == User.hash_password(password, user.salt)
end
