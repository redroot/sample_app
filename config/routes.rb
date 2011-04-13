SampleApp::Application.routes.draw do

  root :to => 'pages#home' # root directory 
  
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  
  match '/signup', :to => 'users#new'
  
  #get "pages/home"

  #get "pages/contact"
  
  #get "pages/about"

  
end
