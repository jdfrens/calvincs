class NewsItem < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :headline
  validates_presence_of :teaser
  validates_presence_of :content
  validates_presence_of :user, :message => 'is invalid'
  validates_associated  :user, :allow_nil => false
  validates_presence_of :goes_live_at
  validates_presence_of :expires_at
  
  def self.find_current
    find(:all, :order => 'expires_at DESC, id ASC').reject do |news_item|
      !news_item.is_current?
    end
  end

  def self.find_filtered_news(filter)
    case filter
    when 'all'
      NewsItem.find(:all, :order => "expires_at DESC, id ASC")
    else
      NewsItem.find_current
    end
  end

  def is_current?
    (goes_live_at <= Time.now) && (expires_at >= Time.now)
  end
        
  def render_content
    RedCloth.new(content, [:lite_mode]).to_html
  end
  
end
