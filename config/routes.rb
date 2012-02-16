NineSisters::Application.routes.draw do
  root :to => "home#index"
  
  namespace :admin do
    resources :articles, :only => %w(create destroy edit index new show update) do
      post :publish, :on => :member, :as => :publish
      post :revert,  :on => :member, :as => :revert
      
      resources :versions, :controller => "article_versions", :only => %w()
    end # resources articles
    resources :categories, :only => %w(create destroy edit index new show update)
    resources :settings, :only => %w(create index)
  end # namespace
  
  resources :articles, :only => %w(show)
  
  resource :user, :only => %w(create new)
  resource :session, :only => %w(create destroy new)
  
  get "*path/:feature" => "categories#find"
  get ":feature" => "categories#find"
end # routes.draw
