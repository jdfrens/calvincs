class RenameDocumentsToPages < ActiveRecord::Migration
  def self.up
    rename_table :documents, :pages
  end

  def self.down
    rename_table :pages, :documents
  end
end
