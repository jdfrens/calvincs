# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  filter_parameter_logging "password"

  #
  # Helpers
  #
  protected
  
  # this is so that I don't have to live on the edge
  # needed for LWT Authentication
  def authenticate_with_http_basic
    nil
  end

  # find most recent updated_at
  def last_updated(items)
    items.compact.map(&:last_updated_dates).flatten.max
  end

  protected
  def rescue_optional_error_file(status_code)
    status = interpret_status(status_code)
    render :template => "/errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
  end

  def local_request?
    true
  end
  
end
