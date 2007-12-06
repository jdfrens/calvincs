class AddPresenterToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :presenter, :string
  end

  def self.down
    remove_column :events, :presenter
  end
end
