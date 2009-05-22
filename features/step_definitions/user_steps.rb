Given /^I am logged in as an editor$/ do
  create_editor
  visit "/users/login"
  fill_in("user[username]", :with => "editor")
  fill_in("user[password]", :with => "secret")
  click_button "Login"
end

Given /^I am not logged in$/ do
  visit "/users/logout"
end

module UserHelpers
  def create_editor
    edit = Privilege.new(:name => "edit")
    edit.save!
    role = Role.new(:name => "editor")
    role.privileges << edit
    role.save!
    user = User.create(:username => "editor", :email_address => "foobar@example.com",
            :password_hash => User.hash_password('secret'), :role => role)
    user.save!
    User.find_by_username("editor").role.name.should == "editor"
  end
end

World(UserHelpers)