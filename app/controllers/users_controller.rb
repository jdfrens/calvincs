class UsersController < ApplicationController
  acts_as_login_controller

  redirect_after_login do |controller|
    { :controller => "home", :action => 'administrate' }
  end

end
