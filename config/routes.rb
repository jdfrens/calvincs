ActionController::Routing::Routes.draw do |map|

  map.home '', :controller => "home"

  # Special Calvin CS routes
  map.view_page 'p/:id', :controller => 'pages', :action => 'show', :id => /\w+/

  map.resources :images
  map.resources :news_items
  map.resources :pages

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
