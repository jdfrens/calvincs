ActionController::Routing::Routes.draw do |map|

  map.home '', :controller => "home"
  map.connect '/feed', :controller => 'home', :action => 'feed', :format => 'atom'

  map.login "/users/login", :controller => "users", :action => "login"
  map.logout "/users/logout", :controller => "users", :action => "logout"

  # Special Calvin CS routes
  map.view_page 'p/:id', :controller => 'pages', :action => 'show', :id => /\w+/

  map.resources :events
  map.resources :colloquia, :controller => 'events'
  map.resources :conferences, :controller => 'events'
  map.resources :courses
  map.resources :images
  map.resources :newsitems
  map.resources :pages
  map.resources :cogs, :controller => 'personnel'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
