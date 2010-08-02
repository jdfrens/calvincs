CalvinCS::Application.routes.draw do
  root :to => 'home#index'
  match '/feed' => 'home#feed', :format => 'atom'
  match '/feed.:format' => 'home#feed'
  match '/sitemap.xml' => 'home#sitemap', :format => 'xml'
  match '/users/login' => 'users#login', :as => :login
  match '/users/logout' => 'users#logout', :as => :logout
  match '/administrate' => 'home#administrate', :as => :administrate
  resources :events
  resources :colloquia, :controller => "events"
  resources :conferences, :controller => "events"
  resources :courses
  resources :images, :as => "pictures" do
    collection do
      get :refresh
    end
  end
  resources :newsitems
  resources :pages, :path => "p"
  resources :people, :controller => "personnel"
  resources :users, :controller => "personnel" do
    member do
      get :editpassword
    end
  end

  match '/:controller(/:action(/:id))'
end
