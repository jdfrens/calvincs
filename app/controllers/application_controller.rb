class ApplicationController < ActionController::Base
  protect_from_forgery

  #
  # Helpers
  #
  protected

  def flash_message(type, text)
      flash[type] ||= []
      flash[type] << text
  end

  def flash_now_message(type, text)
      flash.now[type] ||= []
      flash.now[type] << text
  end

  def last_updated(items)
    items.compact.map(&:last_updated_dates).flatten.max
  end

  def rescue_optional_error_file(status_code)
    status = interpret_status(status_code)
    render :template => "/errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
  end

  def local_request?
    true
  end
  
end
