class NewsController < ApplicationController
  
  restrict_to :admin, :only => [ :new, :save ]
  
  def list
    case params[:id] 
    when 'all'
      @header = "All News"
      @news_items = NewsItem.find(:all)
    else
      @header = "Current News"
      @news_items = NewsItem.find_current
    end
  end
  
  def new
    @news_item = NewsItem.new( :expires_at => 1.month.from_now )
  end
  
  def save
    params[:news_item][:user_id] = current_user.id
    news_item = NewsItem.new(params[:news_item])
    news_item.save!
    redirect_to :action => 'list'
  end
  
end
