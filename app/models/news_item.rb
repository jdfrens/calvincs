class NewsItem < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :user, :message => 'is invalid'
  validates_associated  :user, :allow_nil => false
  validates_presence_of :expires_at
  
  def self.find_current
    find(:all).reject do |news_item|
      news_item.expires_at < Time.now
    end
  end
      
end
