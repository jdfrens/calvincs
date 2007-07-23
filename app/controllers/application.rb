# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_calvincs_session_id'
    
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
  
end
