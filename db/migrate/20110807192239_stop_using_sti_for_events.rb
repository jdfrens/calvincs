class StopUsingStiForEvents < ActiveRecord::Migration
  def up
    rename_column :events, :type, :event_kind
  end

  def down
    rename_column :events, :event_kind, :type
  end
end
