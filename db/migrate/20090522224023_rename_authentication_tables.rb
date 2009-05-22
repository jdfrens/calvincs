class RenameAuthenticationTables < ActiveRecord::Migration
  def self.up
    rename_column :groups_privileges, :group_id, :role_id
    rename_column :users, :group_id, :role_id
    rename_table :groups, :roles
    rename_table :groups_privileges, :privileges_roles
  end

  def self.down
    rename_column :privileges_roles, :role_id, :group_id
    rename_column :users, :role_id, :group_id
    rename_table :roles, :groups
    rename_table :privileges_roles, :groups_privileges
  end
end
