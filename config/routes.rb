SampleApp::Application.routes.draw do

  root :to => 'pages#home' # root directory 
  
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  
  resources :users
  resources :sessions, :only => [:new, :create, :destroy] # get post and delete only, no put
  resources :microposts, :only => [:create, :destroy] # only post and elete, no get

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  #get "pages/home"

  #get "pages/contact"
  
  #get "pages/about"

  
end
