class AddStopTimeToEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :length
    add_column :events, :stop, :datetime
  end

  def self.down
    remove_column :events, :stop
    add_column :events, :length, :integer
  end
end
