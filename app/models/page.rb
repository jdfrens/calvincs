# == Schema Information
# Schema version: 20091012011757
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  identifier :string(255)
#  content    :text
#  title      :string(255)
#  updated_at :datetime
#

class Page < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :content
  validates_uniqueness_of :identifier
  validates_format_of :identifier, :with => /^(\w|_)+$/,
      :message => 'should be like a Java identifier'

  named_scope :normal_pages, :conditions => "identifier not like '!_%' escape '!'"
  named_scope :subpages, :conditions => "identifier like '!_%' escape '!'"

  def self.find_by_an_id(id)
    if id =~ /^\d+/
      find(id)
    else
      find_by_identifier(id)
    end
  end

  def last_updated_dates
    [updated_at]
  end
    
  def random_image(index=-1)
    Image.pick_random(identifier, index)
  end
  
  def url_to
    "/p/" + identifier
  end
  
  def subpage?
    identifier =~ /^_/
  end
  
end
