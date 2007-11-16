class AddDescriptorToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :descriptor, :string
    
    Event.reset_column_information
    Colloquium.find(:all).each do |colloquium|
      colloquium.descriptor = 'colloquium'
      colloquium.save!
    end
    Conference.find(:all).each do |conference|
      conference.descriptor = 'conference'
      conference.save!
    end
  end

  def self.down
    remove_column :events, :descriptor
  end
end
