class NewsItemsController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    if params[:year] =~ /^\d{4}$/
      @year = params[:year].to_i
      @news_items = NewsItem.find_by_year(@year, current_user ? :all : :today)
      @title = "News of #{@year}"
      @last_updated = @news_items.maximum(:updated_at)
    elsif params[:year] == "all"
      @title = "News Archive"
      @years = NewsItem.find_news_years
      render :action => "archive"
    else
      @news_items = NewsItem.find_current
      @title = "Current News"
      @last_updated = @news_items.maximum(:updated_at)
    end
  end

  def show
    @news_item = NewsItem.find(params[:id])
    @title = @news_item.headline
    @last_updated = @news_item.updated_at
  end

  def new
    @news_item = NewsItem.new( :expires_at => 1.month.from_now )
  end

  def create
    params[:news_item][:user_id] = current_user.id
    @news_item = NewsItem.new(params[:news_item])
    if @news_item.save
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid values for the news item'
      render :template => 'news/new'
    end
  end

  def edit
    @news_item = NewsItem.find(params[:id])
    render :action => "new"
  end  

  in_place_edit_for :news_item, :headline

  in_place_edit_for :news_item, :teaser

  def update_news_item_content
    item = NewsItem.find(params[:id])
    item.update_attribute(:content, params[:news_item][:content])
    render :update do |p|
      p.replace_html "news-item-content", :inline => textilize(item.content)
    end
  end

  in_place_edit_for :news_item, :goes_live_at_formatted

  in_place_edit_for :news_item, :expires_at_formatted

  def destroy
    NewsItem.destroy(params[:id])
    redirect_to :controller => 'news_items', :action => 'index'
  end

end
