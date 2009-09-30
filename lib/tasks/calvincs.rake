require 'spec/rake/spectask'

namespace :calvincs do
  desc "Runs the redirection and rewrite expectations for cs.calvin.edu"
  Spec::Rake::SpecTask.new(:redirects) do |t|
    t.spec_files = FileList['deployment/*_spec.rb']
  end

  desc "creates user in editor group with edit privilege"
  task :editor => :environment
  task :editor, [:group, :username] do |t, args|
    fail "user with username #{args.username} exists!" if User.find_by_username(args.username)
    group = Group.find_by_name(args.group)
    salt = generate_salt
    user = User.create!(
            :username => args.username, :email_address => "#{args.username}@calvin.edu",
            :password_hash => User.hash_password('calvin', salt), :salt => salt,
            :group => editor, :activate => true)
    user.save!
    editor.save!
  end

  desc "change the password of a user"
  task :password, [:username] do |t, args|
    user = User.find_by_username(args.username)
    password = get_password
    salt = generate_salt
    user.password_hash = User.hash_password(args.password, salt)
    user.salt = salt
    user.save!
  end

  def get_password(prompt="Enter Password")
     ask(prompt) {|q| q.echo = false}
  end

  def generate_salt()
    (0...4).map{65.+(rand(25)).chr}.join
  end
end