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
    User.create!(hash.merge( :email_address => "#{hash[:username]}@example.edu",
                             :password => "password", :password_confirmation => "password",
                             :role => faculty ))
  end
end
