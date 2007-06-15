class RenameTypeOfDegreeToDegreeType < ActiveRecord::Migration
  def self.up
    rename_column :degrees, :type, :degree_type
  end

  def self.down
    rename_column :degrees, :degree_type, :type
  end
end
