class BlogsController < ApplicationController
  before_filter :find_posts, :only => %w(show)
  
  # GET /blog
  # GET /blogs/:id
  def show; end
  
  def find_blog
    @blog = Blog.find(params[:id])
  end # helper find_blog
  private :find_blog
  
  def find_posts
    find_blog
    @posts = @blog.posts.published.limit(5).offset(5 * (params[:page_id].to_i || 0))
    @posts_count = @blog.posts.published.count
  end # helper find_posts
  private :find_posts
end # controller BlogsController
