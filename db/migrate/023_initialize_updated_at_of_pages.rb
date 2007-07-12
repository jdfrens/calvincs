class InitializeUpdatedAtOfPages < ActiveRecord::Migration
  def self.up
    Page.find(:all).each do |page|
      page.updated_at = Time.now
      page.save!
    end
  end

  def self.down
  end
end
