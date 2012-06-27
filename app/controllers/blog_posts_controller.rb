class BlogPostsController < ApplicationController
  before_filter :find_post,  :only => %w(show)
  
  def show
    @blog = Blog.find(params[:blog_id])
    @post = @blog.posts.find_by_slug(params[:slug])
  end # action show
  
  def find_blog
    @blog = Blog.find(params[:blog_id])
  end # helper find_blog
  
  def find_post
    posts = (@blog || find_blog).posts
    
    return if !(@post = find_post_by_field posts, :slug, params[:slug]).nil?
    return if !(@post = find_post_by_field posts, :id,   params[:slug]).nil?
  end # helper find_post
  
  def find_post_by_field(collection, field, value)
    begin
      return collection.send :"find_by_#{field}", value
    rescue NoMethodError, ActiveRecord::RecordNotFound
      return nil
    end # begin-rescue-end
  end # helper find_post_by_field
end # controller BlogPostsController
