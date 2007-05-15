class NewsController < ApplicationController
  
  restrict_to :admin, :only => [
    :new, :save, :destroy,
    :set_news_item_headline, :set_news_item_teaser,
    ]
  
  def index
    @news_items = NewsItem.find_current
  end
  
  def list
    @news_items = NewsItem.find_filtered_news params[:filter]
  end
  
  def list_table
    @news_items = NewsItem.find_filtered_news params[:filter]
    render :partial => 'newsitems', :layout => false
  end
  
  def view
    @news_item = NewsItem.find(params[:id])
  end
    
  def new
    @news_item = NewsItem.new( :expires_at => 1.month.from_now )
  end
  
  in_place_edit_for :news_item, :headline
  
  in_place_edit_for :news_item, :teaser
  
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
