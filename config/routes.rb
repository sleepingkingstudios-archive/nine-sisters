NineSisters::Application.routes.draw do
  root :to => "blogs#show", :id => (Blog.count > 0 ? Blog.first.id : 0)
  
  namespace :admin do
    # resources :articles, :only => %w(create destroy edit index new show update) do
    #   post :publish, :on => :member, :as => :publish
    #   post :revert,  :on => :member, :as => :revert
    #   
    #   resources :versions, :controller => "article_versions", :only => %w()
    # end # resources articles
    
    resources :blogs, :only => %w(index show) do
      resources :posts, :controller => "blog_posts", :only => %w(create destroy edit new show update)
    end # resources blogs
    
    resources :categories, :only => %w(create destroy edit index new show update)
    resources :settings, :only => %w(create index)
  end # namespace
  
  # resources :articles, :only => %w(show)
  
  resource :user, :only => %w(create new)
  resource :session, :only => %w(create destroy new)
  
  get "/blog/:slug" => "blog_posts#show", :blog_id => (Blog.count > 0 ? Blog.first.id : 0)
  get "/blog" => "blogs#show", :id => (Blog.count > 0 ? Blog.first.id : 0)
  
  # get "*path/:feature" => "categories#find"
  # get ":feature" => "categories#find"
  
  get "/about" => "home#index"
  get "/admin/test" => "home#test"
end # routes.draw
