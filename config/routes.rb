ActionController::Routing::Routes.draw do |map|

  map.home '', :controller => "home"
  map.connect '/feed', :controller => 'home', :action => 'feed', :format => 'atom'
  map.connect '/feed.:format', :controller => 'home', :action => 'feed'

  map.login "/users/login", :controller => "users", :action => "login"
  map.logout "/users/logout", :controller => "users", :action => "logout"
  map.administrate "/administrate", :controller => "home", :action => "administrate"

  map.resources :events
  map.resources :colloquia, :controller => 'events'
  map.resources :conferences, :controller => 'events'
  map.resources :courses
  map.resources :images, :as => 'pictures', :collection => { :refresh => :get }
  map.resources :newsitems
  map.resources :pages, :as => "p"
  map.resources :people, :controller => 'personnel'
  map.resources :users, :controller => 'personnel', :member => { :editpassword => :get }

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
