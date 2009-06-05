class NewsitemsController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    if params[:year] =~ /^\d{4}$/
      @year = params[:year].to_i
      @newsitems = Newsitem.find_by_year(@year, current_user ? :all : :today)
      @title = "News of #{@year}"
      @last_updated = @newsitems.maximum(:updated_at)
    elsif params[:year] == "all"
      @title = "News Archive"
      @years = Newsitem.find_news_years
      render :action => "archive"
    else
      @newsitems = Newsitem.find_current
      @title = "Current News"
      @last_updated = @newsitems.maximum(:updated_at)
    end
  end

  def show
    @newsitem = Newsitem.find(params[:id])
    @title = @newsitem.headline
    @last_updated = @newsitem.updated_at
  end

  def new
    @newsitem = Newsitem.new( :expires_at => 1.month.from_now )
  end

  def create
    params[:newsitem][:user_id] = current_user.id
    @newsitem = Newsitem.new(params[:newsitem])
    if @newsitem.save
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid values for the news item'
      render :template => 'news/new'
    end
  end

  def edit
    @newsitem = Newsitem.find(params[:id])
    render :action => "new"
  end  

  in_place_edit_for :newsitem, :headline

  in_place_edit_for :newsitem, :teaser

  def update_newsitem_content
    item = Newsitem.find(params[:id])
    item.update_attribute(:content, params[:newsitem][:content])
    render :update do |p|
      p.replace_html "news-item-content", :inline => textilize(item.content)
    end
  end

  in_place_edit_for :newsitem, :goes_live_at_formatted

  in_place_edit_for :newsitem, :expires_at_formatted

  def destroy
    Newsitem.destroy(params[:id])
    redirect_to :controller => 'newsitems', :action => 'index'
  end

end
