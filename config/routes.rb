SampleApp::Application.routes.draw do

  root :to => 'pages#home' # root directory 
  
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  
  resources :users do
    member do
      get :following, :followers # what this does it builds subsections e.g. user/1/following
    end
  end
  resources :sessions, :only => [:new, :create, :destroy] # get post and delete only, no put
  resources :microposts, :only => [:create, :destroy] # only post and elete, no get
  resources :relationships, :only => [:create, :destroy]

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  #get "pages/home"

  #get "pages/contact"
  
  #get "pages/about"

  
end
