class UsersController < ApplicationController

  acts_as_login_controller

  redirect_after_login do
    { :controller => "home", :action => 'administrate' }
  end

  redirect_after_logout do
    { :controller => "home", :action => "index" }
  end

end
