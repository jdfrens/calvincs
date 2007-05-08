class AddEmailAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_address, :string
    User.find(:all).each do |user|
      user.email_address = "nobody#{user.id}@nowhere.foo"
      user.save!
    end
 end

  def self.down
    remove_column :users, :email_address
  end
end
