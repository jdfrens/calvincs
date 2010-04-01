class DropPrimaryKeyOfPrivilegesRoles < ActiveRecord::Migration
  def self.up
    remove_column :privileges_roles, :id
  end

  def self.down
  end
end
