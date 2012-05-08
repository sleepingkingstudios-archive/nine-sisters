class BlogPostsController < ApplicationController
  def show
    @blog = Blog.find(params[:blog_id])
    @post = @blog.posts.find_by_slug(params[:slug])
  end # action show
end # controller BlogPostsController
