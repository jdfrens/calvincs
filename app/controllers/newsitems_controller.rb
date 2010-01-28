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
      render "archive"
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
      render :new
    end
  end

  def edit
    @newsitem = Newsitem.find(params[:id])
  end

  def update
    @newsitem = Newsitem.find(params[:id])
    if @newsitem.update_attributes(params[:newsitem])
      redirect_to(@newsitem)
    else
      render "edit"
    end
  end

  def destroy
    Newsitem.destroy(params[:id])
    redirect_to(newsitems_path)
  end

end
