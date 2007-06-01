class NewsController < ApplicationController
  
  restrict_to :admin, :only => [
      :new, :save, :destroy,
      :set_news_item_headline, :set_news_item_teaser,
      :set_news_item_goes_live_at_formatted, :set_news_item_expires_at_formatted,
      ]
  
  def index
    @news_items = NewsItem.find_current
  end
  
  def list
    if (params[:id])
      @news_items = NewsItem.find_filtered_news params[:id]
    else
      redirect_to :action => 'list', :id => 'current'
    end
  end
  
  def view
    @news_item = NewsItem.find(params[:id])
  end
    
  def new
    @news_item = NewsItem.new( :expires_at => 1.month.from_now )
  end
  
  in_place_edit_for :news_item, :headline
  
  in_place_edit_for :news_item, :teaser
  
  in_place_edit_for :news_item, :goes_live_at_formatted
  
  in_place_edit_for :news_item, :expires_at_formatted
  
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
    redirect_to :controller => 'news', :action => 'list', :id => params[:listing]
  end

end
