Given /^I am logged in as an editor$/ do
  create_editor
  visit "/users/login"
  fill_in("user[username]", :with => "editor")
  fill_in("user[password]", :with => "secret")
  click_button "Login"
end

def create_editor
  edit = Privilege.new(:name => "edit")
  edit.save!
  group = Group.new(:name => "editor")
  group.privileges << edit
  group.save!
  user = User.create(:username => "editor", :email_address => "foobar@example.com",
          :password_hash => User.hash_password('secret'), :group => group)
  user.save!
  User.find_by_username("editor").group.name.should == "editor"  
end