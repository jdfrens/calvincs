class HomeController < ApplicationController

  restrict_to :edit, :only => 'administrate'

  def index
    @title = "computing from a Christian perspective"
    @content = Page.find_by_identifier('_home_page')
    @splash_image = Image.pick_random('homepage')
    @newsitems = Newsitem.find_current
    @todays_events = Event.find_by_today
    @this_weeks_events = Event.within_week
    if @content.nil?
      flash[:error] = 'Please define a _home_page page.'
      redirect_to(new_page_path(:id => "_home_page"))
    elsif @splash_image.nil?
      flash[:error] = 'Please tag an image with "homepage".'
      redirect_to(images_path)
    else
      @last_updated = last_updated(@newsitems + [@content])
    end
  end

  def administrate
  end

  def feed
    @newsitems = Newsitem.find_current
    @todays_events = Event.find_by_today
    @weeks_events = Event.within_week
    @updated_at = @newsitems.maximum(:updated_at)

    respond_to do |format|
      format.atom
    end
  end

  def sitemap
    @pages = Page.normal_pages
    @courses = Course.all
    @people = User.non_admins
    
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
