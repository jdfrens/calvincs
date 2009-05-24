class AddFieldsToAuthenticationSystem < ActiveRecord::Migration
  def self.up
    add_timestamps :roles
    add_timestamps :privileges

    add_index :privileges_roles, :role_id
    add_index :privileges_roles, :privilege_id
    add_index :privileges_roles, [:role_id, :privilege_id], :uniq => true

    add_column :users, :salt, :string
    add_column :users, :active, :boolean
    add_column :users, :remember_me_token, :string
    add_column :users, :remember_me_token_expires_at, :datetime
    add_index :users, :role_id
    add_index :users, :email_address
    add_index :users, [:remember_me_token, :remember_me_token_expires_at], :name => "index_users_on_remember_me_token"

    create_table :user_reminders do |t|
      t.integer :user_id
      t.string :token
      t.datetime :expires_at
      t.timestamps
    end
    add_index :user_reminders, :user_id
    add_index :user_reminders, [:user_id, :token, :expires_at]
  end

  def self.down
    remove_timestamps :roles
    remove_timestamps :privileges

    remove_column :users, :salt
    remove_column :users, :active
    remove_column :users, :remember_me_token
    remove_column :users, :remember_me_token_expires_at

    remove_table :user_reminders
  end
end
