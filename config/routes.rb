CalvinCS::Application.routes.draw do
  root :to => 'home#index'

  match '/feed.:format' => 'home#feed'
  match '/sitemap.xml' => 'home#sitemap', :format => 'xml'

  match '/users/login' => 'users#login', :as => :login
  match '/users/logout' => 'users#logout', :as => :logout
  match '/administrate' => 'home#administrate', :as => :administrate

  resources :courses
  resources :events
  resources :images, :path => "pictures" do
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
end
