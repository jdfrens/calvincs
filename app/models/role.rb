# == Schema Information
# Schema version: 20100315182611
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :privileges
  
  validates_presence_of :name

  def self.users_ordered_by_name(name)
    find_by_name(name).users.sort { |a, b| a.last_name <=> b.last_name }
  end
end
