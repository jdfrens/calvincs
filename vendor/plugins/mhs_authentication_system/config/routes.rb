Rails.application.routes.draw do
  match "users/login" => "users#login", :as => :login
  match "users/:id/login/:token" => "users#login", :as => :reminder_login
  match "users/logout" => "users#logout", :as => :logout
  match "users/reminder" => "users#reminder", :as => :reminder
  match "users/profile" => "users#profile", :as => :profile
  match "users/signup" => "users#signup", :as => :signup
end
