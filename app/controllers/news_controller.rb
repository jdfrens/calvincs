class NewsController < ApplicationController
  
  restrict_to :admin, :only => [ :new, :save, :destroy ]
  
  def index
    @news_items = NewsItem.find_current
  end
  
  def list
    case params[:id] 
    when 'all'
      @header = "All News"
      @news_items = NewsItem.find(:all, :order => "expires_at DESC, id ASC")
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
    @news_item = NewsItem.new(params[:news_item])
    if @news_item.save
      redirect_to :action => 'list'
    else
      flash[:error] = 'Invalid values for the news item'
      render :template => 'news/new'
    end
  end
  
  def destroy
    NewsItem.destroy(params[:id])
    redirect_to :controller => 'news', :action => 'list'
  end
  
end
