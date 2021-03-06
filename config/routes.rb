NineSisters::Application.routes.draw do
  root :to => "blogs#show", :id => 1
  
  namespace :admin do
    # resources :articles, :only => %w(create destroy edit index new show update) do
    #   post :publish, :on => :member, :as => :publish
    #   post :revert,  :on => :member, :as => :revert
    #   
    #   resources :versions, :controller => "article_versions", :only => %w()
    # end # resources articles
    
    resources :blogs, :only => %w(index show) do
      resources :posts, :controller => "blog_posts", :only => %w(create destroy edit index new show update) do
        get :publish, :on => :member
      end # resources posts
    end # resources blogs
    
    resources :tags, :only => %w(create edit index new show update)
    
    resources :settings, :only => %w(create index)
    
    # resources :categories, :only => %w(create destroy edit index new show update)
  end # namespace
  
  # resources :articles, :only => %w(show)
  
  resource :user, :only => %w(create new)
  resource :session, :only => %w(create destroy new)
  
  # Blog Posts
  get "/blog/posts/:post_id" => "blog_posts#show", :blog_id => 1
  
  # Blog
  get "/blog/pages/:page_id" => "blogs#show", :id => 1
  get "/blog/tags/:tag/pages/:page_id" => "blogs#show", :id => 1
  get "/blog/tags/:tag" => "blogs#show", :id => 1
  get "/blog/tags" => redirect("/blog")
  get "/blog" => "blogs#show", :id => 1
  
  # get "*path/:feature" => "categories#find"
  # get ":feature" => "categories#find"
  
  get "/about" => "home#index"
  get "/admin/test" => "home#test"
end # routes.draw
