class AddContactInformationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :office_phone,    :string
    add_column :users, :office_location, :string
  end

  def self.down
    remove_column :users, :office_phone
    remove_column :users, :office_location
  end
end
