namespace :calvincs do
  desc "creates user in editor group with edit privilege"
  task :editor => :environment
  task :editor, [:username] do |t, args|
    fail "user with username #{args.username} exists!" if User.find_by_username(args.username)
    editor = Group.find_or_create_by_name("editor")
    edit = Privilege.find_by_name("edit")
    editor.privileges << edit
    user = User.create!(:username => args.username, :email_address => "#{args.name}@example.com",
            :password_hash => User.hash_password('calvin'), :group => editor)
    user.save!
    editor.save!
    edit.save!
  end

  desc "change the password of a user"
  task :password, [:username, :password] do |t, args|
    user = User.find_by_username(args.username)
    user.password_hash = User.hash_password(args.password)
    user.save!
  end
end