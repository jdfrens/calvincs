class ApplicationController < ActionController::Base
  protect_from_forgery

  #
  # Helpers
  #
  protected

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
