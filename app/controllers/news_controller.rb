class NewsController < ApplicationController
  
  restrict_to :edit, :except => [ :index, :list, :view, ]
  
  def index
    @news_items = NewsItem.find_current
    @title = "News"
    @last_updated = @news_items.map(&:updated_at).max
  end
  
  def list
    if params[:id]
      @year = params[:id].to_i
      @news_items = NewsItem.find_by_year(@year, current_user ? :all : :today)
      @title = "News of #{@year}"
      @last_updated = @news_items.map(&:updated_at).max
    else
      redirect_to :action => 'list', :id => Time.now.year
    end
  end
  
  def view
    @news_item = NewsItem.find(params[:id])
    @title = @news_item.headline
    @last_updated = @news_item.updated_at
  end
    
  def new
    @news_item = NewsItem.new( :expires_at => 1.month.from_now )
  end
  
  in_place_edit_for :news_item, :headline
  
  in_place_edit_for :news_item, :teaser
  
  def update_news_item_content
    item = NewsItem.find(params[:id])
    item.update_attribute(:content, params[:news_item][:content])
    render :update do |p|
      p.replace_html "news_item_content", :inline => item.render_content
    end
  end
  
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
