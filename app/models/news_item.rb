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
  
  def last_updated_dates
    [updated_at]
  end

  def goes_live_at_formatted
    goes_live_at.strftime '%m/%d/%Y'
  end
  
  def goes_live_at_formatted=(value)
    self.goes_live_at = Time.parse(value)
  end

  def expires_at_formatted
    expires_at.strftime '%m/%d/%Y'
  end
  
  def expires_at_formatted=(value)
    self.expires_at = Time.parse(value)
  end

  def is_current?
    (goes_live_at <= Time.now) && (expires_at >= Time.now)
  end
        
  def render_content
    "<p>" + RedCloth.new(content, [:lite_mode]).to_html + "</p>"
  end
  
  def render_teaser
    RedCloth.new(teaser, [:lite_mode]).to_html
  end
  
end
